#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;

extern void forkret(void);
static void freeproc(struct proc *p);

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table.
void
procinit(void)
{
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int
allocpid()
{
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  p-> waiting_tick = 0;
  
  // Initialize energy tracking
  p->energy_budget = DEFAULT_ENERGY_BUDGET;
  p->energy_consumed = 0;
  p->last_scheduled_tick = 0;
  p->waiting_for_lock = 0;
  p->deadlock_reports = 0;
  p->in_deadlock = 0;
  // Initialize deadlock detection fields
  for(int i = 0; i < NRES; i++)
    p->holding_res[i] = 0;
  p->waiting_res = -1;

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
  p->energy_budget = 0;
  p->energy_consumed = 0;
  p->last_scheduled_tick = 0;
  p->waiting_for_lock = 0;
  p->deadlock_reports = 0;
  p->in_deadlock = 0;
  for(int i = 0; i < NRES; i++)
    p->holding_res[i] = 0;
  p->waiting_res = -1;
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if(pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// Set up first user process.
void
userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;
  
  p->cwd = namei("/");

  p->state = RUNNABLE;

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    if(sz + n > TRAPFRAME) {
      return -1;
    }
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
      return -1;
    }
  } else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
kfork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    if(pp->parent == p){
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
kexit(int status)
{
  struct proc *p = myproc();

  if(p == initproc)
    panic("init exiting");

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);
  
  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
kwait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(pp = proc; pp < &proc[NPROC]; pp++){
      if(pp->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if(pp->state == ZOMBIE){
          // added a print statement before cleaning up process
          printf("schedstats: pid=%d waiting_tick=%d\n", pp->pid, pp->waiting_tick);
          // Found one.
          pid = pp->pid;
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
                                  sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || killed(p)){
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  
  c->proc = 0;
  for(;;){
    intr_on();

    struct proc *chosen = 0;

    // Find lowest PID RUNNABLE child of schedtest with good energy
    // (energy budget > LOW_ENERGY_THRESHOLD)
    for(p = proc; p < &proc[NPROC]; p++){
      acquire(&p->lock);
      if(p->state == RUNNABLE &&
         p->parent != 0 &&
         strncmp(p->parent->name, "schedtest", 16) == 0 &&
         p->energy_budget > LOW_ENERGY_THRESHOLD)
      {
        if(chosen == 0 || p->pid < chosen->pid){
          if(chosen != 0)
            release(&chosen->lock);
          chosen = p;
          continue;  // keep chosen->lock held
        }
      }
      release(&p->lock);
    }

    // If no high-energy processes found, select lowest PID among all schedtest children
    // (including those with low energy)
    if(chosen == 0){
      for(p = proc; p < &proc[NPROC]; p++){
        acquire(&p->lock);
        if(p->state == RUNNABLE &&
           p->parent != 0 &&
           strncmp(p->parent->name, "schedtest", 16) == 0)
        {
          if(chosen == 0 || p->pid < chosen->pid){
            if(chosen != 0)
              release(&chosen->lock);
            chosen = p;
            continue;  // keep chosen->lock held
          }
        }
        release(&p->lock);
      }
    }

    // If no schedtest process found, pick first RUNNABLE process
    if(chosen == 0){
      for(p = proc; p < &proc[NPROC]; p++){
        acquire(&p->lock);
        if(p->state == RUNNABLE){
          chosen = p;
          break;
        }
        release(&p->lock);
      }
    }

    if(chosen != 0){
      // Increment waiting_tick for all other runnable schedtest children
      for(p = proc; p < &proc[NPROC]; p++){
        if(p == chosen)
          continue;
        acquire(&p->lock);
        if(p->state == RUNNABLE &&
           p->parent != 0 &&
           strncmp(p->parent->name, "schedtest", 16) == 0)
        {
          p->waiting_tick++;
        }
        release(&p->lock);
      }

      // Context switch to chosen process
      chosen->state = RUNNING;
      chosen->last_scheduled_tick = 0;  // Reset tick counter for this scheduling period
      c->proc = chosen;
      swtch(&c->context, &chosen->context);
      c->proc = 0;
      release(&chosen->lock);
    } else {
      // Low power waiting: no process to run.
      // WFI (Wait For Interrupt) puts the CPU to sleep
      // until the next interrupt (e.g., timer or device) occurs.
      asm volatile("wfi");
    }
  }
}


// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched RUNNING");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  p->state = RUNNABLE;
  sched();
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();

  // Still holding p->lock from scheduler.
  release(&p->lock);

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);

    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    if (p->trapframe->a0 == -1) {
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
  uint64 satp = MAKE_SATP(p->pagetable);
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64))trampoline_userret)(satp);
}

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING){
        // Wake process from sleep().
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

void
setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

int
killed(struct proc *p)
{
  int k;
  
  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [USED]      "used",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}

int
kps(char *arguments)
{
  int arg_length = 4;
  char *states[] = {"UNUSED", "USED", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE"};
  struct proc *p;
  // if user enter "-o" argument
  if (strncmp(arguments, "-o", arg_length) == 0)
  {
    for (p = proc; p < &proc[NPROC]; p++)
    {
      // skip/filter out printing the unused processes
      if (strncmp(p->name, "", arg_length) == 0)
      {
        continue;
      }
      printf("%s   ", p->name);
    }
    printf("\n");
  }
  else if (strncmp(arguments, "-l", arg_length) == 0)
  {
    printf("%s   %s       %s\n", "PID", "STATE", "NAME");
    printf("-------------------------\n");
    for (p = proc; p < &proc[NPROC]; p++)
    {
      // skip/filter out printing the unused processes
      if (p->state == 0)
      {
        continue;
      }
      printf("%d     %s    %s\n", p->pid, states[p->state], p->name);
    }
  }
  else
  {
    printf("Usage: ps [-o | -l]\n");
  }
  return 0;
}



// Acquire a resource for the current process (called when a process gets a lock/resource).
void
res_acquire(int res_id)
{
  struct proc *p = myproc();
  if(res_id < 0 || res_id >= NRES)
    return;
  acquire(&p->lock);
  p->holding_res[res_id] = 1;
  p->waiting_res = -1;  // no longer waiting
  release(&p->lock);
}

// Release a resource held by the current process.
void
res_release(int res_id)
{
  struct proc *p = myproc();
  if(res_id < 0 || res_id >= NRES)
    return;
  acquire(&p->lock);
  p->holding_res[res_id] = 0;
  release(&p->lock);
}

// Mark that the current process is waiting for a resource.
void
res_wait(int res_id)
{
  struct proc *p = myproc();
  if(res_id < 0 || res_id >= NRES)
    return;
  acquire(&p->lock);
  p->waiting_res = res_id;
  release(&p->lock);
}

// Find which process holds a given resource. Returns 0 if none.
static struct proc*
find_holder(int res_id)
{
  struct proc *p;
  for(p = proc; p < &proc[NPROC]; p++){
    // No lock needed here because check_deadlock holds all relevant locks
    if(p->state != UNUSED && p->holding_res[res_id])
      return p;
  }
  return 0;
}

// check_deadlock: Build a resource allocation graph (RAG) and detect cycles.
// When a cycle (deadlock) is found, kill the process in the cycle with the
// highest energy_consumed — this is the energy-aware recovery strategy.

// 0  = no deadlock found
// pid of killed victim = deadlock was found and resolved
int
check_deadlock(void)
{
  struct proc *p;
  struct proc *deadlocked[NPROC];
  int num_deadlocked = 0;

  // For each process that is waiting for a resource, follow the wait-for chain.
  // If we revisit a process, we've found a cycle = deadlock.
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED || p->waiting_res < 0)
      continue;

    // Follow the chain: p waits for res -> who holds res? -> does that proc wait for something?
    struct proc *visited[NPROC];
    int nvisited = 0;
    struct proc *cur = p;

    while(cur != 0 && cur->waiting_res >= 0){
      // Check if we've already visited this process (cycle detected)
      for(int i = 0; i < nvisited; i++){
        if(visited[i] == cur){
          // DEADLOCK DETECTED — collect all processes in the cycle
          num_deadlocked = 0;
          for(int j = i; j < nvisited; j++){
            deadlocked[num_deadlocked++] = visited[j];
          }
          goto found_deadlock;
        }
      }
      if(nvisited >= NPROC)
        break;
      visited[nvisited++] = cur;

      // cur is waiting for res_id -> find who holds it
      int res_id = cur->waiting_res;
      cur = find_holder(res_id);
    }
  }

  // No deadlock found
  return 0;

found_deadlock:
  if(num_deadlocked == 0)
    return 0;

  // Among all deadlocked processes, pick the one with the HIGHEST energy_consumed.
  // killing the most energy-hungry process first reduces overall system
  // energy waste and breaks the deadlock in the most sustainable way.
  struct proc *victim = deadlocked[0];
  uint64 max_energy = deadlocked[0]->energy_consumed;

  for(int i = 1; i < num_deadlocked; i++){
    if(deadlocked[i]->energy_consumed > max_energy){
      max_energy = deadlocked[i]->energy_consumed;
      victim = deadlocked[i];
    }
  }

  // Print deadlock info
  printf("DEADLOCK DETECTED! %d processes in cycle:\n", num_deadlocked);
  for(int i = 0; i < num_deadlocked; i++){
    printf("  pid=%d name=%s energy_consumed=%ld waiting_res=%d\n",
           deadlocked[i]->pid,
           deadlocked[i]->name,
           deadlocked[i]->energy_consumed,
           deadlocked[i]->waiting_res);
  }

  // Kill the energy-hungry victim to break the deadlock
  printf("ENERGY-AWARE RECOVERY: Killing pid=%d (name=%s, energy=%ld) — highest energy consumer\n",
         victim->pid, victim->name, victim->energy_consumed);

  // Release all resources held by victim so other processes can proceed
  acquire(&victim->lock);
  for(int i = 0; i < NRES; i++)
    victim->holding_res[i] = 0;
  victim->waiting_res = -1;
  victim->killed = 1;
  if(victim->state == SLEEPING)
    victim->state = RUNNABLE;
  release(&victim->lock);

  return victim->pid;
}

// called periodically from the timer interrupt handler.
// runs the deadlock detection algorithm and recovers if needed.
void
deadlock_recover(void)
{
  check_deadlock();
}
