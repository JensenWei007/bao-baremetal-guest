#include <plat.h>
#include <renesas_rlin3.h>

struct renesas_rlin3 *uart  = (void*) PLAT_UART_ADDR;

void uart_init(){
    renesas_rlin3_uart_init(uart);
}

void uart_putc(char c)
{
    renesas_rlin3_uart_putc(uart, c);
}

char uart_getchar(void)
{
    return 'n';
}

void uart_enable_rxirq()
{
    //uart8250_enable_rx_int();
}

void uart_clear_rxirq()
{
    //uart8250_interrupt_handler(); 
}
