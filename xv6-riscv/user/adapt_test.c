#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  printf("\n=== Adaptive Ticking / System Heartbeat Test ===\n");
  
  printf("\n[Test 1] Busy spin waiting for 20 ticks.\n");
  printf("         Because a process is RUNNABLE, the system uses the FAST timer_interval.\n");
  int start = uptime();
  while(uptime() - start < 20) {
    // Busy loop keeps the CPU spinning, so chosen != 0 in the scheduler.
    // The timer will not stretch.
  }
  printf("         [Done] That took about 2 seconds wall-clock time.\n");

  printf("\n[Test 2] Sleeping for 20 ticks.\n");
  printf("         Because NO processes are RUNNABLE, the scheduler stretches the timer 10x.\n");
  printf("         You should notice this takes ~10x longer (roughly 20 seconds) in real life!\n");
  
  // pause goes to SLEEPING state (this OS variant uses pause instead of sleep). 
  // The scheduler has chosen == 0. The system goes into low power wfi mode and stretches the timer.
  pause(20);
  
  printf("         [Done] Woke up! The CPU slumbered cleanly and saved energy.\n");
  printf("\n=== Test Finished ===\n\n");
  
  exit(0);
}
