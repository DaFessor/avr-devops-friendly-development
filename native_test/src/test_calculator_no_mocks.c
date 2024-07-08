#include "unity.h"
#include "calculator.h"

void test_calculator_add()
{
    calctask_t task = {.operand1 = 5, .operand2 = 3};
    TEST_ASSERT_TRUE(calculate(CALC_ADD, &task));
    TEST_ASSERT_EQUAL(8, task.result);
}

void test_calculator_sub()
{
    calctask_t task = {.operand1 = 5, .operand2 = 3};
    TEST_ASSERT_TRUE(calculate(CALC_SUB, &task));
    TEST_ASSERT_EQUAL(2, task.result);
}

void test_calculator_mul()
{
    calctask_t task = {.operand1 = 5, .operand2 = 3};
    TEST_ASSERT_TRUE(calculate(CALC_MUL, &task));
    TEST_ASSERT_EQUAL(15, task.result);
}

void test_calculator_div()
{
    calctask_t task = {.operand1 = 12, .operand2 = 3};
    TEST_ASSERT_TRUE(calculate(CALC_DIV, &task));
    TEST_ASSERT_EQUAL(4, task.result);
}

void test_calculator_div_by_zero()
{
    calctask_t task = {.operand1 = 12, .operand2 = 0};
    TEST_ASSERT_FALSE(calculate(CALC_DIV, &task));
}