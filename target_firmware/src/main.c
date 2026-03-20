#include <stdio.h>
#include <util/delay.h>
#include <avr/io.h>
#include "serial_com.h"
#include <stdlib.h>

/* Exercise 7.2

int main()
{
    unsigned int counter = 0;
    // Initialize the UART for serial communication
    uart_init();
    // Set all pins of PORTB as output
    DDRB = 0xff;
    do
    {
        // Turn led on
        PORTB = 0xff;
        // Print message to serial

        printf("Counter: %d\n\r",counter++);
        // Wait 0,25 seconds and then turn led off again
        PORTB = 0x0;
        // Wait 1 second and then repeat loop
        _delay_ms(1000);
    } while (1);
}
    */

/* Exercise 7.3
int main()
{
// Initialize the UART for serial communication
uart_init();
// Buffer for reading input from serial/stdin
uint8_t input_buffer[100];
do
{
    // Print message to serial
    printf("Hallo from Arduino!\n\r");
    // Read input from serial/stdin and ignore it
    scanf("%s", input_buffer);
    printf("You wrote: %s, Arschloch!\n\r", input_buffer);
} while (1);
}
*/

/* Exercise 7.4
int main()
{

    // Initialize the UART for serial communication
    uart_init();
    DDRB = 0xff;
    // Buffer for reading input from serial/stdin
    int8_t input_buffer[100];

    do
    {
        // Turn led on

        printf("Write number:\n\r");

        scanf("%s", input_buffer);

        printf("You wrote: %s, Arschloch!\n\r", input_buffer);

        int times = atoi(input_buffer);

        for (int i = 0; i < times; i++)
        {
            PORTB = 0xff;
            _delay_ms(67);
            PORTB = 0x0;
            _delay_ms(67);
        }

        // Print message to serial

    } while (1);
}
    */
int main()
{
    // Initialize the UART for serial communication
    uart_init();
    // Set prescaler to /1024
    TCCR1B |= (1 << CS12) | (1 << CS10);
    while (1)
    {
        printf("TCNT1 %u\n\r", TCNT1);
        _delay_ms(500);
    }
}