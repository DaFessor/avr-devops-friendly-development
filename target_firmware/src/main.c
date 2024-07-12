#include <stdio.h>
#include <util/delay.h>
#include <avr/io.h>
#include "serial_com.h"

int main()
{
    uint32_t counter = 0;
    static char buf[20];
    uart_init();
    DDRB = 0xff;

    do
    {
        PORTB = 0xff;
        __builtin_avr_delay_cycles(4000000);
        PORTB = 0x0;
        __builtin_avr_delay_cycles(4000000);
       printf("Counter: %d\n\r", counter++);
    } while (1);
}