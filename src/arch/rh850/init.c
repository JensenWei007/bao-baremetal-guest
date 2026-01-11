#include <core.h>
#include <clock.h>
#include <cpu.h>

extern void _start();

__attribute__((weak))
void arch_init(){
#ifndef SINGLE_CORE
    unsigned long hart_id = get_cpuid();
    unsigned long master_hart_id = get_mastercpuid();
    //if (hart_id == master_hart_id) {
    //}
#endif
    clock_init();
}
