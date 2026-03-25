// Energy scheduling test program
// This program demonstrates the energy-efficient scheduling in xv6
// It creates child processes with different workloads and tracks their energy consumption

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  struct energy_info info;
  int pid = getpid();
  
  printf("Energy Scheduling Test\n");
  printf("=======================\n\n");
  
  printf("Main process PID: %d\n", pid);
  
  // Get initial energy info
  if(getenergy(&info) == 0) {
    printf("Initial Energy Status:\n");
    printf("  PID: %d\n", (int)info.pid);
    printf("  Energy Budget: %d\n", (int)info.energy_budget);
    printf("  Energy Consumed: %d\n", (int)info.energy_consumed);
  } else {
    printf("Error getting energy info\n");
  }
  
  printf("\nStarting test: CPU-intensive workload...\n");
  
  // Perform some CPU-intensive work
  volatile int sum = 0;
  for(int i = 0; i < 1000000; i++) {
    sum += i;
  }
  
  printf("Work completed. Final energy status:\n");
  if(getenergy(&info) == 0) {
    printf("  PID: %d\n", (int)info.pid);
    printf("  Energy Budget: %d\n", (int)info.energy_budget);
    printf("  Energy Consumed: %d\n", (int)info.energy_consumed);
  }
  
  printf("\nEnergy test completed!\n");
  
  exit(0);
}
