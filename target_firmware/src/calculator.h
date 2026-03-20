#pragma once

#include <stdint.h>
#include <stdbool.h>

typedef enum
{
    CALC_ADD = 0,
    CALC_SUB,
    CALC_MUL,
    CALC_DIV
} calcop_t;

typedef struct
{
    int32_t operand1;
    int32_t operand2;
    int32_t result;
} calctask_t;

bool calculate(calcop_t operation, calctask_t *task);