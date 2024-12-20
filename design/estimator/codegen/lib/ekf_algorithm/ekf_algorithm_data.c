/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ekf_algorithm_data.c
 *
 * Code generation for function 'ekf_algorithm_data'
 *
 */

/* Include files */
#include "ekf_algorithm_data.h"
#include "rt_nonfinite.h"

/* Variable Definitions */
const double dv[9] = {0.5, 0.0, 0.0, 0.0, 50.0, 0.0, 0.0, 0.0, 50.0};

const double dv1[9] = {2.0, -0.0, 0.0, -0.0, 0.02, -0.0, -0.0, -0.0, 0.02};

boolean_T isInitialized_ekf_algorithm = false;

/* End of code generation (ekf_algorithm_data.c) */
