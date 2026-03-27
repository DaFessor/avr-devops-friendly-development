#include "fff.h"
#include "unity.h"
#include "serial_com.h"
#include <util/delay.h>
#include <avr/io.h>

#include "calculator.h"

DEFINE_FFF_GLOBALS;

FAKE_VALUE_FUNC(int, add_op, calctask_t*);

void setUp(void)
{
    static int uart_initialized = 0;

    if (!uart_initialized)
    {
        uart_init();
        uart_initialized = 1;
        DDRB = 0xff;
        for (int i = 0; i < 20; i++)
        {
            PORTB = 0xff;
            _delay_ms(50.0);
            PORTB = 0x0;
            _delay_ms(50.0);
        }
    }
}

void test_calculate_Call_add_op_Returns_success(void)
{
    // Arrange
    calctask_t calctask;
    add_op_fake.return_val = true;
    // Act
    int c = calculate(CALC_ADD, &calctask);
    // Assert
    TEST_ASSERT_TRUE(c); // Add_op returns true and so should calculate
    TEST_ASSERT_TRUE(add_op_fake.call_count == 1); // add_op should be called once
    TEST_ASSERT_TRUE(add_op_fake.arg0_val == &calctask); // add_op should be called with the correct argument
}