/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ekf_algorithm.h
 *
 * Code generation for function 'ekf_algorithm'
 *
 */

#ifndef EKF_ALGORITHM_H
#define EKF_ALGORITHM_H

/* Include files */
#include "rtwtypes.h"
#include <stddef.h>
#include <stdlib.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Function Declarations */
extern void ekf_algorithm(const double x[13], const double P[169],
                          const double u[4], const double y[8], double t,
                          const double Q[169], const double R[64], double T,
                          double step, double x_new[13], double P_new[169]);

#ifdef __cplusplus
}
#endif

#endif
/* End of code generation (ekf_algorithm.h) */
