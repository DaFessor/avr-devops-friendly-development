#include "calculator.h"
#include <stddef.h>
#include "add_op.h"
#include "sub_op.h"
#include "mul_op.h"
#include "div_op.h"

bool calculate(calcop_t operation, calctask_t *task)
{
    if (task == NULL)
    {
        return false;
    }

    switch (operation)
    {
    case CALC_ADD:
        return add_op(task);
    case CALC_SUB:
        return subtract_op(task);
    case CALC_MUL:
        return multiply_op(task);
    case CALC_DIV:
        return divide_op(task);
    default:
        return false;
    }
}