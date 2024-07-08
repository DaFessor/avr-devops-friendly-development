#include "unity.h"
#include "sub_op.h"

void test_subtract_op_0_0_returns_0(void)
{
    calctask_t task = {.operand1 = 0, .operand2 = 0};
    TEST_ASSERT_TRUE(subtract_op(&task));
    TEST_ASSERT_EQUAL(0, task.result);
}

void test_subtract_op_100_100_returns_0(void)
{
    calctask_t task = {.operand1 = 100, .operand2 = 100};
    TEST_ASSERT_TRUE(subtract_op(&task));
    TEST_ASSERT_EQUAL(0, task.result);
}

void test_subtract_op_100_neg100_returns_200(void)
{
    calctask_t task = {.operand1 = 100, .operand2 = -100};
    TEST_ASSERT_TRUE(subtract_op(&task));
    TEST_ASSERT_EQUAL(200, task.result);
}

void test_subtract_op_neg100_neg100_returns_0(void)
{
    calctask_t task = {.operand1 = -100, .operand2 = -100};
    TEST_ASSERT_TRUE(subtract_op(&task));
    TEST_ASSERT_EQUAL(0, task.result);
}

void test_subtract_op_neg100_100_returns_neg200(void)
{
    calctask_t task = {.operand1 = -100, .operand2 = 100};
    TEST_ASSERT_TRUE(subtract_op(&task));
    TEST_ASSERT_EQUAL(-200, task.result);
}

void test_subtract_op_100_0_returns_100(void)
{
    calctask_t task = {.operand1 = 100, .operand2 = 0};
    TEST_ASSERT_TRUE(subtract_op(&task));
    TEST_ASSERT_EQUAL(100, task.result);
}