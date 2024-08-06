#include <stdio.h>
#include <util/delay.h>
#include <avr/io.h>
#include "serial_com.h"

int main()
{
    unsigned int counter = 0;
    uart_init();
    DDRB = 0xff;

    do
    {
        PORTB = 0xff;
        __builtin_avr_delay_cycles(4000000);
        PORTB = 0x0;
        __builtin_avr_delay_cycles(4000000);
       printf("Counter: %u\n\r", counter++);
    } while (1);
}