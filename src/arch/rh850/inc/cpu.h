#ifndef CPU_H
#define CPU_H

#include <core.h>

static inline unsigned long get_cpuid(){
    register unsigned long hartid asm("r10");
    return hartid;
}

static inline unsigned long get_mastercpuid(){
    register unsigned long hartid asm("r11");
    return hartid;
}

static inline bool cpu_is_master(){
    return get_cpuid() == get_mastercpuid();
}

#endif
