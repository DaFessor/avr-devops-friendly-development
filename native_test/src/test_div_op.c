#include "unity.h"
#include "div_op.h"

void test_div_op_0_0_returns_false(void)
{
    calctask_t task = {.operand1 = 0, .operand2 = 0};
    TEST_ASSERT_FALSE(divide_op(&task));
}

void test_div_op_1_0_returns_false(void)
{
    calctask_t task = {.operand1 = 1, .operand2 = 0};
    TEST_ASSERT_FALSE(divide_op(&task));
}

void test_div_op_100_100_returns_1(void)
{
    calctask_t task = {.operand1 = 100, .operand2 = 100};
    TEST_ASSERT_TRUE(divide_op(&task));
    TEST_ASSERT_EQUAL(1, task.result);
}

void test_div_op_100_neg100_returns_neg1(void)
{
    calctask_t task = {.operand1 = 100, .operand2 = -100};
    TEST_ASSERT_TRUE(divide_op(&task));
    TEST_ASSERT_EQUAL(-1, task.result);
}

void test_div_op_neg100_neg100_returns_1(void)
{
    calctask_t task = {.operand1 = -100, .operand2 = -100};
    TEST_ASSERT_TRUE(divide_op(&task));
    TEST_ASSERT_EQUAL(1, task.result);
}
