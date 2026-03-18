#include <stdio.h>
#include <util/delay.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#include "serial_com.h"

ISR(TIMER1_OVF_vect)
{
    // Toggle the LED connected to PB5 (Arduino Uno's built-in LED)
    PORTB ^= (1 << PORTB7);
}

int main()
{
    // Initialize the UART for serial communication
    uart_init();
    // Set all pins of PORTB as output (for the LED)
    DDRB = 0xff;
    PORTB = 0x00;
// Buffer for reading input from serial/stdin
#define INPUT_BUFFER_SIZE 100
    char input_buffer[INPUT_BUFFER_SIZE];

    TCCR1B = 0;             // - stop timer while we set it up
    TCCR1A = 0;             // - normal mode, OC1A/OC1B disconnected
    TCNT1 = 0;              // - reset timer count to 0
    TIFR1 |= (1 << TOV1);   // - clear any stale flag
    TIMSK1 |= (1 << TOIE1); // - enable overflow interrupt
    /*
        Normal mode, prescaler/256 (last instruction also starts timer).
        The timer will count up from 0 to 0xffff, and then start all over
        - whenever the timer goes back to 0 an interrupt is generated.
        A prescaler of 256 means that the clock (16MHz) is divided by 256 = 62500.
        So the reset/interrupt freq. is 65536/62500 = 1,048576 Hz.
        Writing to TCCR1B also starts the timer, so we do it at the end of the setup
    */
    TCCR1B |= 0x04;

    // Enable global interrupts
    sei();

    do
    {
        // Print message to serial
        printf("Hallo from Arduino, let's communicate!\n\r");
        // Read input from serial/stdin into input_buffer
        int c, index = 0;
        while (index < INPUT_BUFFER_SIZE - 1)
        {
            c = getchar();
            if (c == EOF || c == '\n' || c == '\r')
            {
                break;
            }
            input_buffer[index++] = c;
            // Echo the character read back to the sender
            putchar(c);
        }
        // Null-terminate the string we read
        input_buffer[index] = '\0';
        printf("\n\rYou wrote %d chars: %s\n\r", index, input_buffer);
    } while (1);
}