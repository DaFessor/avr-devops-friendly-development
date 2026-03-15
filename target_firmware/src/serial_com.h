// Calling uart_init() will initialize the UART peripheral for serial communication.
// This function should be called before any other UART functions are used.
// The function sets the baud rate to 115200, data bits, stop bits, and parity for
// the UART communication. On top of that, the UART gets connected to stdin and stdout,
// so that printf and scanf can be used for serial communication.

void uart_init();
