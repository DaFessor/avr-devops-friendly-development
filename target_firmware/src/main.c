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
        _delay_ms(250);
        PORTB = 0x0;
        _delay_ms(250);
        printf(buf,"%ld",counter++);
    } while (1);
}