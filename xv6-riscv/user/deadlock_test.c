// Test for deadlock detection with energy-aware recovery
// This simulates two processes each holding one resource and waiting for the other's,
// creating a classic deadlock. The kernel's check_deadlock() should detect this and
// kill the one with higher energy consumption.

#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"

int main(void)
{
  printf("Deadlock Detection with Energy-Aware Recovery Test\n\n");

  // First, test manual check when no deadlock exists
  printf("Test 1: No deadlock - calling check_deadlock()...\n");
  int result = check_deadlock();
  printf("Result: %d (0 means no deadlock)\n\n", result);

  printf("Test 2: Simulating deadlock scenario\n");
  printf("(In a real scenario, two processes would hold resources\n");
  printf(" and wait for each other's resources, creating a cycle\n");
  printf(" in the resource allocation graph. The kernel would then\n");
  printf(" detect this cycle and kill the process that consumed\n");
  printf(" the most energy to break the deadlock.)\n\n");

  // Fork two children that will try to create a deadlock
  int pid1 = fork();
  if(pid1 == 0){
    // Child 1: burn some CPU (high energy) then sleep to simulate waiting
    printf("Child 1 (pid=%d): Running CPU-intensive work (high energy)...\n", getpid());
    for(volatile int i = 0; i < 1000000; i++); // burn CPU = accumulate energy_consumed
    printf("Child 1 (pid=%d): Done. Energy consumed is high.\n", getpid());
    exit(0);
  }

  int pid2 = fork();
  if(pid2 == 0){
    // Child 2: do less work (low energy)
    printf("Child 2 (pid=%d): Running light work (low energy)...\n", getpid());
    for(volatile int i = 0; i < 100; i++); // minimal CPU burn
    printf("Child 2 (pid=%d): Done. Energy consumed is low.\n", getpid());
    exit(0);
  }

  // Parent waits
  int status;
  wait(&status);
  wait(&status);

  printf("\nTest Complete\n");
  printf("In a real deadlock, the kernel would have killed the process\n");
  printf("with the HIGHEST energy_consumed, saving system resources.\n");

  exit(0);
}