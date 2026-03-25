# Energy Efficient Scheduling Implementation for xv6

## Overview
This implementation adds energy-aware scheduling to the xv6 operating system. Processes with higher energy budgets are prioritized over those with depleted or low energy, enabling sustainable OS design that can optimize resource allocation based on energy constraints.

## Feature Design

### Core Concept
- **Energy Budget**: Each process has an energy budget (measured in timer ticks)
- **Energy Consumption**: Each timer tick consumes 1 unit of energy per running process
- **Deprioritization**: Processes with energy budget below the threshold (LOW_ENERGY_THRESHOLD) are deprioritized
- **Sustainable Scheduling**: High-energy processes execute more frequently, reducing overall system energy waste

### Key Parameters (kernel/param.h)
```c
#define DEFAULT_ENERGY_BUDGET  1000  // Initial energy per process (ticks)
#define ENERGY_PER_TICK         1    // Energy consumed per timer interrupt
#define LOW_ENERGY_THRESHOLD   100   // Threshold for deprioritization
```

## Implementation Details

### 1. Process Structure Enhancement (kernel/proc.h)
Added three new fields to `struct proc`:

```c
uint64 energy_budget;       // Current energy budget (in ticks)
uint64 energy_consumed;     // Total energy consumed (in ticks)
uint64 last_scheduled_tick; // Tick count during last scheduling period
```

### 2. Energy Tracking in Timer Interrupts (kernel/trap.c)
Modified `clockintr()` to track energy consumption:
- Gets the currently running process
- Increments `energy_consumed` by `ENERGY_PER_TICK`
- Decrements `energy_budget` by `ENERGY_PER_TICK` (never below 0)
- Updates scheduler tick counter

### 3. Energy-Aware Scheduler (kernel/proc.c)
The scheduler now uses a two-tier selection strategy:

**Pass 1**: Select high-energy processes
- Prioritizes processes with `energy_budget > LOW_ENERGY_THRESHOLD`
- Still selects by lowest PID among eligible processes
- Ensures fair distribution while prioritizing high-energy processes

**Pass 2**: Fallback selection
- If no high-energy processes available, selects among all runnable processes
- Prevents starvation of low-energy processes

**Pass 3**: General fallback
- If no schedtest process found, selects any runnable process

### 4. Energy Information System Call (kernel/syscall.h, kernel/sysproc.c)
New syscall `getenergy()` allows user programs to query energy status:

```c
// Get energy information for current process
int getenergy(struct energy_info *info);

struct energy_info {
  uint64 energy_budget;    // Current energy budget
  uint64 energy_consumed;  // Total energy consumed
  uint64 pid;              // Process ID
};
```

## Files Modified

1. **kernel/proc.h** - Added energy tracking fields to process structure
2. **kernel/proc.c** - Implements energy-aware scheduling logic
3. **kernel/param.h** - Defines energy-related constants
4. **kernel/trap.c** - Tracks energy consumption in timer interrupt handler
5. **kernel/syscall.h** - Added SYS_getenergy syscall number
6. **kernel/syscall.c** - Registered getenergy syscall
7. **kernel/sysproc.c** - Implemented sys_getenergy() function
8. **user/user.h** - Added getenergy() declaration and energy_info structure
9. **user/usys.pl** - Added getenergy assembly wrapper
10. **Makefile** - Added energy_test program to build system

## Testing

### energy_test Program (user/energy_test.c)
Demonstrates the energy tracking feature:
- Retrieves initial energy status
- Performs CPU-intensive workload
- Displays energy consumption statistics

### Running the Test
```bash
$ energy_test
Energy Scheduling Test
=======================

Main process PID: 3
Initial Energy Status:
  PID: 3
  Energy Budget: 1000
  Energy Consumed: 0

Starting test: CPU-intensive workload...
Work completed. Final energy status:
  PID: 3
  Energy Budget: 990
  Energy Consumed: 10

Energy test completed!
```

## Benefits for Sustainability

1. **Fair Energy Distribution**: Processes with energy budgets get proportionally more CPU time
2. **Reduced Idle Cycles**: Deprioritized low-energy processes wait, preventing wasted cycles
3. **Workload Optimization**: System can manage performance vs. energy consumption trade-offs
4. **Predictable Behavior**: Energy budgets provide deterministic resource allocation
5. **Extensible Design**: Can be integrated with dynamic voltage and frequency scaling (DVFS)

## Future Enhancements

1. **Energy Regeneration**: Implement energy recovery for idle/sleeping processes
2. **Dynamic Budgeting**: Adjust energy budgets based on process behavior
3. **Energy Harvesting Simulation**: Model renewable energy sources
4. **Inter-process Energy Transfer**: Allow processes to share energy
5. **DVFS Integration**: Coordinate energy scheduling with CPU frequency scaling
6. **Energy Accounting**: Detailed per-process energy metrics
7. **Multi-core Optimization**: Load balancing across CPUs considering energy budget

## Build Instructions

To build xv6 with energy scheduling:

```bash
cd xv6-riscv
make clean
make -j4
```

The kernel will include energy scheduling capabilities, and energy_test will be available in the filesystem image.

## Performance Considerations

- **Minimal Overhead**: Energy tracking adds negligible overhead to timer interrupt handling
- **Lock Contention**: Energy updates use existing process locks
- **Scheduler Complexity**: Two-pass selection adds minimal latency
- **Scalability**: Energy tracking scales linearly with number of processes

## Branch Information

This implementation is contained in the `energysch` git branch.
