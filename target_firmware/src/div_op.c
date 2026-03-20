#include "div_op.h"

int divide_op(calctask_t *task)
{
    /*  Note that this function does not check for NULL pointers,
        because it is assumed that the caller has already done so.
    */
    
    /* Check for divide by zero */
    if (task->operand2 == 0)
    {
        return 0;
    }
    task->result = task->operand1 / task->operand2;
    return 1;
}