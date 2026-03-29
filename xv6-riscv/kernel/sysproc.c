#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "vm.h"
#include "sleeplock.h"

static struct sleeplock demo_locks[2];
static int demo_locks_inited = 0;

static void
ensure_demo_locks_inited(void)
{
  if(demo_locks_inited)
    return;

  initsleeplock(&demo_locks[0], "demo_lock_0");
  initsleeplock(&demo_locks[1], "demo_lock_1");
  demo_locks_inited = 1;
}

uint64
sys_kps(void)
{
  int arg_length = 4;
  int first_argument = 0;
  int max_num_copy = 128;
  char kernal_buffer[arg_length];
  if (argstr(first_argument, kernal_buffer, max_num_copy) < 0)
  {
    // error
    return -1;
  }
  return kps(kernal_buffer);

}

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  addr = myproc()->sz;

  if(t == SBRK_EAGER || n < 0) {
    if(growproc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
      return -1;
    if(addr + n > TRAPFRAME)
      return -1;
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// Get energy information for the current process
uint64
sys_getenergy(void)
{
  uint64 addr;
  struct proc *p = myproc();
  
  argaddr(0, &addr);
  
  if(addr == 0)
    return -1;
  
  // Create a temporary buffer to hold the energy info
  // We use a struct that matches the user-space definition
  uint64 energy_data[3];  // energy_budget, energy_consumed, pid
  
  acquire(&p->lock);
  energy_data[0] = p->energy_budget;
  energy_data[1] = p->energy_consumed;
  energy_data[2] = p->pid;
  release(&p->lock);
  
  // Copy the energy information to user space
  if(copyout(p->pagetable, addr, (char *)energy_data, sizeof(energy_data)) < 0)
    return -1;
  
  return 0;
}

uint64
sys_dlockacq(void)
{
  int lockid;

  argint(0, &lockid);
  if(lockid < 0 || lockid > 1)
    return -1;

  ensure_demo_locks_inited();
  acquiresleep(&demo_locks[lockid]);
  return 0;
}

uint64
sys_dlockrel(void)
{
  int lockid;

  argint(0, &lockid);
  if(lockid < 0 || lockid > 1)
    return -1;

  ensure_demo_locks_inited();
  if(!holdingsleep(&demo_locks[lockid]))
    return -1;

  releasesleep(&demo_locks[lockid]);
  return 0;
}

// deadlock recovery system call
uint64
sys_check_deadlock(void)
{
  return kcheck_deadlock();
}
