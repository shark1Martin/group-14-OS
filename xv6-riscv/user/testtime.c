#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main() {
    uint64 t;
    asm volatile("rdtime %0" : "=r" (t));
    printf("time: %l\n", t);
    exit(0);
}
