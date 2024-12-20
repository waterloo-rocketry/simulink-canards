/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ode45.h
 *
 * Code generation for function 'ode45'
 *
 */

#ifndef ODE45_H
#define ODE45_H

/* Include files */
#include "ekf_algorithm_types.h"
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void ode45(const double ode_workspace_u[4], const emxArray_real_T *tspan,
           const double b_y0[13], emxArray_real_T *varargout_1,
           emxArray_real_T *varargout_2);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (ode45.h) */
