#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int pid = fork();

  if(pid < 0){
    printf("deadlock_demo: fork failed\n");
    exit(1);
  }

  if(pid == 0){
    // Child grabs lock 1 first, then tries lock 0.
    printf("child: acquiring lock 1\n");
    dlockacq(1);
    pause(20);
    printf("child: acquiring lock 0 (this should trigger deadlock warning)\n");
    dlockacq(0);
    printf("child: unexpected progress\n");
    exit(0);
  }

  // Parent grabs lock 0 first, then tries lock 1.
  printf("parent: acquiring lock 0\n");
  dlockacq(0);
  pause(20);
  printf("parent: acquiring lock 1\n");
  dlockacq(1);
  printf("parent: unexpected progress\n");

  // Unreachable in deadlock scenario.
  dlockrel(1);
  dlockrel(0);
  wait(0);
  exit(0);
}
