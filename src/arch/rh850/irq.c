#include <irq.h>

void rh850_irq_handle(unsigned int int_id){
    irq_handle(int_id);
}

void irq_enable(unsigned id) {
    
}

void irq_set_prio(unsigned id, unsigned prio) {
    
}

void irq_send_ipi(unsigned long target_cpu_mask) {
    
}
