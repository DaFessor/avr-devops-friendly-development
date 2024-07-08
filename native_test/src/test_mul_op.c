#include "unity.h"
#include "mul_op.h"

void test_multiply_op_0_0_returns_0(void)
{
    calctask_t task = {.operand1 = 0, .operand2 = 0};
    TEST_ASSERT_TRUE(multiply_op(&task));
    TEST_ASSERT_EQUAL(0, task.result);
}

void test_multiply_op_100_100_returns_10000(void)
{
    calctask_t task = {.operand1 = 100, .operand2 = 100};
    TEST_ASSERT_TRUE(multiply_op(&task));
    TEST_ASSERT_EQUAL(10000, task.result);
}

void test_multiply_op_100_neg100_returns_neg10000(void)
{
    calctask_t task = {.operand1 = 100, .operand2 = -100};
    TEST_ASSERT_TRUE(multiply_op(&task));
    TEST_ASSERT_EQUAL(-10000, task.result);
}

void test_multiply_op_neg100_neg100_returns_10000(void)
{
    calctask_t task = {.operand1 = -100, .operand2 = -100};
    TEST_ASSERT_TRUE(multiply_op(&task));
    TEST_ASSERT_EQUAL(10000, task.result);
}

void test_multiply_op_neg100_100_returns_neg10000(void)
{
    calctask_t task = {.operand1 = -100, .operand2 = 100};
    TEST_ASSERT_TRUE(multiply_op(&task));
    TEST_ASSERT_EQUAL(-10000, task.result);
}
