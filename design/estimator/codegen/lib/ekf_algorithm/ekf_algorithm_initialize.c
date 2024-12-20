/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ekf_algorithm_initialize.c
 *
 * Code generation for function 'ekf_algorithm_initialize'
 *
 */

/* Include files */
#include "ekf_algorithm_initialize.h"
#include "ekf_algorithm_data.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void ekf_algorithm_initialize(void)
{
  rt_InitInfAndNaN();
  isInitialized_ekf_algorithm = true;
}

/* End of code generation (ekf_algorithm_initialize.c) */
