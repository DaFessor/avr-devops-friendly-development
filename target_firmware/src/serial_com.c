#include "serial_com.h"

/* Setup some serial parameters. The baud rate is set at 115200,
 * which results in an error of 2.1% with a 16MHz clock. To avoid
 * a warning we set the tolerance to 3 (%).
 */
#define BAUD 115200
#define BAUD_TOL 3
#include <util/setbaud.h>
#include <avr/io.h>
#include <stdio.h>

static int uart_putchar(char c, FILE *stream)
{
    /* Wait for empty transmit buffer */
    while (!(UCSR0A & (1 << UDRE0)))
        ;
    /* Put data into buffer, sends the data */
    UDR0 = c;
    return 0;
}

static int uart_getchar(FILE *stream)
{
    /* Wait for data to be received */
    while (!(UCSR0A & (1 << RXC0)))
        ;
    /* Get and return received data from buffer */
    return UDR0;
}

static FILE uart_output = FDEV_SETUP_STREAM(uart_putchar, NULL, _FDEV_SETUP_WRITE);
static FILE uart_input = FDEV_SETUP_STREAM(NULL, uart_getchar, _FDEV_SETUP_READ);

void uart_init()
{
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;
#if USE_2X
    UCSR0A |= _BV(U2X0);
#else
    UCSR0A &= ~(_BV(U2X0));
#endif
    UCSR0C = _BV(UCSZ01) | _BV(UCSZ00); /* 8-bit data, no parity, 1 stop */
    UCSR0B = _BV(RXEN0) | _BV(TXEN0);   /* Enable RX and TX, 8-bit data  */
    stdout = &uart_output;
    stdin = &uart_input;
}