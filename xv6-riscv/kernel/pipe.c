#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "proc.h"
#include "fs.h"
#include "sleeplock.h"
#include "file.h"

#define PIPESIZE 512

struct pipe {
  // flag[0] for writer process 0, flag[1] for reader, process 1
  volatile int flag[2];   
  volatile int turn;      

  char data[PIPESIZE];
  uint nread;    
  uint nwrite;    
  int readopen;   
  int writeopen;  
};

// Peterson's lock acquire
// id = 0 for writer, id = 1 for reader
static void
peterson_acquire(struct pipe *pi, int id)
{
  int other = 1 - id;
  pi->flag[id] = 1;        // I want to enter
  pi->turn = other;        // But I give the other process a chance first

  // Memory fence to ensure the above stores are visible before the while check
  __sync_synchronize();

  // Busy-wait while the OTHER process also wants in AND it's the other's turn
  while(pi->flag[other] == 1 && pi->turn == other)
    ;
}

// Peterson's lock release
static void
peterson_release(struct pipe *pi, int id)
{
  __sync_synchronize();
  pi->flag[id] = 0;       // I no longer want to be in the critical section
}

int
pipealloc(struct file **f0, struct file **f1)
{
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    goto bad;
  pi->readopen = 1;
  pi->writeopen = 1;
  pi->nwrite = 0;
  pi->nread = 0;

  // Initialize Peterson's variables (instead of initlock)
  pi->flag[0] = 0;
  pi->flag[1] = 0;
  pi->turn = 0;

  (*f0)->type = FD_PIPE;
  (*f0)->readable = 1;
  (*f0)->writable = 0;
  (*f0)->pipe = pi;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = pi;
  return 0;

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}

void
pipeclose(struct pipe *pi, int writable)
{
  // Determine our process id for Peterson's: writer = 0, reader = 1
  int id = writable ? 0 : 1;

  peterson_acquire(pi, id);
  if(writable){
    pi->writeopen = 0;
    wakeup(&pi->nread);
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    peterson_release(pi, id);
    kfree((char*)pi);
  } else
    peterson_release(pi, id);
}

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
  int i = 0;
  struct proc *pr = myproc();

  // Writer is process 0 in Peterson's algorithm
  peterson_acquire(pi, 0);
  while(i < n){
    if(pi->readopen == 0 || killed(pr)){
      peterson_release(pi, 0);
      return -1;
    }
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      // Release Peterson's lock before sleeping so the reader can acquire it
      peterson_release(pi, 0);
      // Sleep on nwrite — the reader will wake us when it reads
      sleep(&pi->nwrite, 0);
      // Re-acquire Peterson's lock after waking up
      peterson_acquire(pi, 0);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
        break;
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
      i++;
    }
  }
  wakeup(&pi->nread);
  peterson_release(pi, 0);

  return i;
}

int
piperead(struct pipe *pi, uint64 addr, int n)
{
  int i;
  struct proc *pr = myproc();
  char ch;

  // Reader is process 1 in Peterson's algorithm
  peterson_acquire(pi, 1);
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    if(killed(pr)){
      peterson_release(pi, 1);
      return -1;
    }
    // Release Peterson's lock before sleeping so the writer can acquire it
    peterson_release(pi, 1);
    // Sleep on nread — the writer will wake us when it writes
    sleep(&pi->nread, 0);
    // Re-acquire Peterson's lock after waking up
    peterson_acquire(pi, 1);
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
      if(i == 0)
        i = -1;
      break;
    }
    pi->nread++;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
  peterson_release(pi, 1);
  return i;
}
