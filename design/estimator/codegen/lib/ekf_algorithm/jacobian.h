/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * jacobian.h
 *
 * Code generation for function 'jacobian'
 *
 */

#ifndef JACOBIAN_H
#define JACOBIAN_H

/* Include files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void jacobian(const double x[13], double h, double Jx[169]);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (jacobian.h) */
