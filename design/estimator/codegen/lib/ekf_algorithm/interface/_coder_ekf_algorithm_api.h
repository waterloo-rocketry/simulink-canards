/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * _coder_ekf_algorithm_api.h
 *
 * Code generation for function 'ekf_algorithm'
 *
 */

#ifndef _CODER_EKF_ALGORITHM_API_H
#define _CODER_EKF_ALGORITHM_API_H

/* Include files */
#include "emlrt.h"
#include "mex.h"
#include "tmwtypes.h"
#include <string.h>

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
void ekf_algorithm(real_T x[13], real_T P[169], real_T u[4], real_T y[8],
                   real_T t, real_T Q[169], real_T R[64], real_T T, real_T step,
                   real_T x_new[13], real_T P_new[169]);

void ekf_algorithm_api(const mxArray *const prhs[9], int32_T nlhs,
                       const mxArray *plhs[2]);

void ekf_algorithm_atexit(void);

void ekf_algorithm_initialize(void);

void ekf_algorithm_terminate(void);

void ekf_algorithm_xil_shutdown(void);

void ekf_algorithm_xil_terminate(void);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (_coder_ekf_algorithm_api.h) */
