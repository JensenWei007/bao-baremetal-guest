#ifndef ARCH_TIMER_H
#define ARCH_TIMER_H

#include <plat.h>

#define TIMER_FREQ (PLAT_TIMER_FREQ)

void timer_enable()
{
}

uint64_t timer_get()
{
    return 1;
}

void timer_set(uint64_t n)
{
    
}


#endif /* ARCH_TIMER_H */
