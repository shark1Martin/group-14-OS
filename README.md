# Sustainable xv6 — Group 14

An extended version of xv6, enhanced with four kernel-level features focused on **energy efficiency**, **deadlock resilience**, and **adaptive system behavior**.

---

## About

This project builds on top of xv6-riscv by introducing four new features that address sustainability concerns found in real-world operating systems. Each feature modifies the kernel directly and is designed to integrate cleanly with the others.

---

## Features

### 1. Energy-Aware Scheduler

**Problem:** Traditional round-robin schedulers treat all processes equally regardless of how much CPU time they have already consumed. This can lead to resource-hungry processes starving others and wasting energy by running indefinitely without limits.

**Solution:** Each process is assigned an energy budget (measured in timer ticks) when it is created. Every time a process runs for a tick, its budget is decremented. The scheduler uses a two-tier selection strategy — processes with sufficient energy remaining are prioritized, while those that have depleted their budget below a configurable threshold are deprioritized. This encourages fair distribution of CPU time and provides a foundation for energy-conscious workload management.

**Key additions:**
- `energy_budget`, `energy_consumed`, and `last_scheduled_tick` fields in the process structure
- Two-pass scheduling: high-energy processes first, then any runnable process
- `getenergy()` system call to query a process's energy status from user space

### 2. Deadlock Detection Algorithm

**Problem:** Deadlocks occur when two or more processes are each waiting for a resource held by another, forming a circular dependency. In a system without detection, deadlocked processes remain stuck indefinitely, consuming memory and preventing progress.

**Solution:** The kernel implements deadlock detection through two complementary mechanisms:

- **Resource Allocation Graph (RAG) cycle detection** — the `check_deadlock()` system call scans all processes, builds a wait-for chain based on which resources each process holds and is waiting for, and detects cycles that indicate a deadlock.
- **Lock-level detection** — the `would_create_deadlock()` function in the sleep lock subsystem checks at lock acquisition time whether granting a lock request would create a circular wait, catching deadlocks before they fully form.

**Key additions:**
- `holding_res[]` and `waiting_res` fields in the process structure for resource tracking
- `check_deadlock()` system call (syscall #26)
- `dlockacq()` and `dlockrel()` system calls for demo lock management
- Periodic automatic detection via a configurable timer interval (`DEADLOCK_CHECK_INTERVAL`)

### 3. Deadlock Recovery (Energy-Aware)

**Problem:** Detecting a deadlock is only half the problem — the system also needs a way to break the cycle and allow the remaining processes to continue. Naively killing a random process can lead to unnecessary loss of work.

**Solution:** When a deadlock is detected, the kernel selects a victim process using an energy-aware strategy: the process in the cycle with the **highest `energy_consumed`** value is chosen. The rationale is that a process that has already consumed the most energy has had the most opportunity to make progress, making it the least costly to terminate from a fairness perspective. The victim's held resources are explicitly released before it is killed, ensuring that surviving processes can proceed without remaining permanently blocked.

**Key additions:**
- `energy_aware_deadlock_recovery()` for lock-level recovery
- Full resource release logic in the RAG-based `check_deadlock()` path
- `deadlock_recover()` function called periodically from the timer interrupt handler

### 4. Adaptive Interrupt Timer

**Problem:** A fixed timer interrupt interval is a one-size-fits-all approach. Under heavy load, frequent interrupts waste CPU cycles on context switching overhead. Under light load, infrequent interrupts cause unnecessary latency and idle energy consumption.

**Solution:** The adaptive interrupt timer dynamically adjusts the timer interrupt frequency based on system activity. When the system is busy with many runnable processes, the interval can be tuned to reduce unnecessary overhead. When the system is mostly idle, the interval adjusts to minimize wakeups and save energy. This works in conjunction with the energy-aware scheduler to provide a more responsive and efficient system.

---

## Building and Running

### Prerequisites

- RISC-V GNU toolchain (`riscv64-unknown-elf-gcc`)
- QEMU compiled for `riscv64-softmmu`

### Build

```bash
cd xv6-riscv
make clean
make -j$(nproc)
```

### Run

```bash
make qemu
```

### Test Programs

Once inside the xv6 shell:

```bash
energy_test      # Demonstrates energy tracking and scheduler behavior
deadlock_test    # Tests deadlock detection syscall and energy differentiation
deadlock_demo    # Triggers an actual deadlock with opposing lock order
```

Exit QEMU with `Ctrl+A` then `X`.

---

## Project Structure

```
xv6-riscv/
├── kernel/
│   ├── proc.c          # Scheduler, deadlock detection, energy tracking
│   ├── proc.h          # Process struct with energy and resource fields
│   ├── trap.c          # Timer interrupt handler with energy and deadlock hooks
│   ├── sleeplock.c     # Lock-level deadlock detection and recovery
│   ├── param.h         # Configurable constants (energy, deadlock, resources)
│   ├── syscall.c/h     # System call dispatch
│   └── defs.h          # Kernel function declarations
├── user/
│   ├── energy_test.c   # Energy scheduling demo
│   ├── deadlock_test.c # Deadlock detection test
│   ├── deadlock_demo.c # Deadlock scenario demo
│   └── usys.pl         # System call stubs
└── Makefile
```

---

## Configuration

Tunable parameters in `kernel/param.h`:

| Parameter | Default | Description |
|-----------|---------|-------------|
| `DEFAULT_ENERGY_BUDGET` | 1000 | Initial energy budget per process (ticks) |
| `ENERGY_PER_TICK` | 1 | Energy consumed per timer tick |
| `LOW_ENERGY_THRESHOLD` | 100 | Budget level below which a process is deprioritized |
| `NRES` | 16 | Maximum number of tracked resources for deadlock detection |
| `DEADLOCK_CHECK_INTERVAL` | 100 | Timer ticks between automatic deadlock checks |

---

## Team

**Group 14**
