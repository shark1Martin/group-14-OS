#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


// Dummy calculation function to simulate CPU burst
void cpu_burst(int iterations) {
    
    int start = uptime();        // ticks since boot
    while (uptime() - start < iterations*10) {
            // busy wait: burn CPU
    }
}


void child_process(int child_id) {
    int burst_input;
    // int margin (n)
    
    int j;
    for (j = 0; j < 3; j++) {
        // increasing bursts
        // first child is shortest, last child is longest
        burst_input = 1+getpid();

        // decreasing bursts
        // so that first child is longest and last child is shortest
        //burst_input = 13-getpid(); // where n >= max_pid // so burst_input isn't negative
        cpu_burst(burst_input);
        
    }
}

int main(void) {
    int i;
    
    for (i = 0; i < 5; i++) {
        int pid = fork();
        
        if (pid < 0) {
            printf("Fork failed for child %d\n", i);
            exit(1);
        } else if (pid == 0) {
            
            child_process(i + 1);
            exit(0);  
        } else {
            
            printf("Parent: Forked child %d with PID %d\n", i + 1, pid);
        }
    }
    
    
   
    
    for (i = 0; i < 5; i++) {
        wait(0);
    }
    
    
    exit(0);
}
