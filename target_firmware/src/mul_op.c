#include "mul_op.h"

int multiply_op(calctask_t *task)
{
    /*  Note that this function does not check for NULL pointers,
        because it is assumed that the caller has already done so.
    */
    task->result = task->operand1 * task->operand2;
    return 1;
}