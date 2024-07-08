#include "unity.h"
#include "calculator.h"
#include "sub_op.h"
#include "mul_op.h"
#include "div_op.h"
#include "mocks/Mockadd_op.h"

int fake_add_op(calctask_t *task, int numcalls)
{
    task->result = task->operand1 + task->operand2;
    return 1;
}

void setUp(void)
{
    add_op_AddCallback(fake_add_op);
}

void test_calculator_add()
{
    calctask_t task = {.operand1 = 5, .operand2 = 3};
    add_op_ExpectAndReturn(&task, 1);
    TEST_ASSERT_TRUE(calculate(CALC_ADD, &task));
    TEST_ASSERT_EQUAL(8, task.result);
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