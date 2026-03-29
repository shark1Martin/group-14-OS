#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  printf("Deadlock Detection with Energy-Aware Recovery Demo\n");
  printf("Two processes will try to acquire locks in opposite order.\n");
  printf("When deadlock is detected, the process with highest energy\n");
  printf("consumption will be killed to break the deadlock.\n\n");

  int pid = fork();

  if(pid < 0){
    printf("deadlock_demo: fork failed\n");
    exit(1);
  }

  if(pid == 0){
    // Child burns some CPU to increase energy_consumed
    // this makes the child the higher-energy process
    for(int i = 0; i < 1000000; i++)
      ;  // busy loop to consume energy ticks

    // Child grabs lock 1 first, then tries lock 0.
    printf("child (pid %d): acquiring lock 1\n", getpid());
    dlockacq(1);
    pause(20);
    printf("child (pid %d): acquiring lock 0 (should trigger deadlock + recovery)\n", getpid());
    dlockacq(0);
    printf("child: if you see this, child survived the deadlock\n");
    dlockrel(0);
    dlockrel(1);
    exit(0);
  }

  // Parent grabs lock 0 first, then tries lock 1.
  printf("parent (pid %d): acquiring lock 0\n", getpid());
  dlockacq(0);
  pause(20);
  printf("parent (pid %d): acquiring lock 1\n", getpid());
  dlockacq(1);
  printf("parent: if you see this, parent survived the deadlock\n");

  dlockrel(1);
  dlockrel(0);

  // Also demonstrate the check_deadlock syscall
  printf("\nCalling check_deadlock() syscall...\n");
  int result = check_deadlock();
  printf("check_deadlock returned: %d (0 = no deadlock found)\n", result);

  wait(0);
  printf("\nDemo complete\n");
  exit(0);
}
