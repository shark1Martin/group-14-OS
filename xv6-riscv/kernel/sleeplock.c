// Sleeping locks

#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "sleeplock.h"

extern struct proc proc[NPROC];

static struct proc*
pid2proc(int pid)
{
  struct proc *p;

  if(pid <= 0)
    return 0;

  for(p = proc; p < &proc[NPROC]; p++){
    if(p->pid == pid && p->state != UNUSED)
      return p;
  }
  return 0;
}

// Detect whether adding edge current_proc -> target_lock holder
// would create a cycle in the wait-for graph.
static int
would_create_deadlock(struct proc *current_proc, struct sleeplock *target_lock)
{
  int owner_pid;
  int hops = 0;

  if(current_proc == 0 || target_lock == 0)
    return 0;

  owner_pid = target_lock->pid;
  while(owner_pid > 0 && hops < NPROC){
    struct proc *owner = pid2proc(owner_pid);
    struct sleeplock *next_lock;

    if(owner == 0)
      return 0;
    if(owner->pid == current_proc->pid)
      return 1;

    next_lock = owner->waiting_for_lock;
    if(next_lock == 0 || next_lock->locked == 0)
      return 0;

    owner_pid = next_lock->pid;
    hops++;
  }

  return 0;
}

static int
energy_aware_deadlock_recovery(struct proc *current_proc, struct sleeplock *target_lock)
{
  struct proc *victim = 0;
  uint64 max_energy = 0;
  int owner_pid;
  int hops = 0;
  int start_pid = current_proc->pid;

  // Step 1: Mark current_proc as part of the deadlock
  current_proc->in_deadlock = 1;

  // Consider current_proc as a candidate victim
  if(current_proc->energy_consumed > max_energy){
    max_energy = current_proc->energy_consumed;
    victim = current_proc;
  }

  // Step 2: Walk the cycle, marking each process & tracking energy
  owner_pid = target_lock->pid;
  while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
    struct proc *owner = pid2proc(owner_pid);
    struct sleeplock *next_lock;

    if(owner == 0)
      break;

    owner->in_deadlock = 1;

    // Pick the process that consumed the most energy
    if(owner->energy_consumed > max_energy){
      max_energy = owner->energy_consumed;
      victim = owner;
    }

    next_lock = owner->waiting_for_lock;
    if(next_lock == 0 || next_lock->locked == 0)
      break;

    owner_pid = next_lock->pid;
    hops++;
  }

  // Kill the highest-energy victim to break the deadlock
  if(victim != 0){
    printf("deadlock recovery: killing pid %d (energy_consumed=%d) to break deadlock\n",
           victim->pid, (int)victim->energy_consumed);

    // Mark victim as killed 
    // it will exit when it next returns to user space
    victim->killed = 1;

    // If the victim is sleeping, wake it up so it can notice it's been killed
    if(victim->state == SLEEPING){
      victim->state = RUNNABLE;
    }

    // Clear the deadlock flags for all processes that were in the cycle
    current_proc->in_deadlock = 0;
    owner_pid = target_lock->pid;
    hops = 0;
    while(owner_pid > 0 && owner_pid != start_pid && hops < NPROC){
      struct proc *owner = pid2proc(owner_pid);
      struct sleeplock *next_lock;

      if(owner == 0)
        break;

      owner->in_deadlock = 0;

      next_lock = owner->waiting_for_lock;
      if(next_lock == 0 || next_lock->locked == 0)
        break;

      owner_pid = next_lock->pid;
      hops++;
    }

    return victim->pid;
  }

  return -1;  // should not happen if a deadlock was truly detected
}

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
}

void
acquiresleep(struct sleeplock *lk)
{
  struct proc *p = myproc();

  acquire(&lk->lk);
  while (lk->locked) {
    p->waiting_for_lock = lk;
    if(would_create_deadlock(p, lk)){
      p->deadlock_reports++;
      printf("deadlock warning: pid %d waits for %s held by pid %d\n",
             p->pid, lk->name, lk->pid);
      // break the deadlock by killing the highest energy process in deadlock cycle
      energy_aware_deadlock_recovery(p, lk);
    }
    sleep(lk, &lk->lk);
  }
  p->waiting_for_lock = 0;
  lk->locked = 1;
  lk->pid = p->pid;
  release(&lk->lk);
}

void
releasesleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
  release(&lk->lk);
  return r;
}



