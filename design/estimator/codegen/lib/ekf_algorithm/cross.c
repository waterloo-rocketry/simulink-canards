/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * cross.c
 *
 * Code generation for function 'cross'
 *
 */

/* Include files */
#include "cross.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void cross(const creal_T a[3], creal_T c[3])
{
  double b_c1_tmp_im;
  double b_c1_tmp_re;
  double c1_tmp_im;
  double c1_tmp_re;
  double c2_tmp_im;
  double c2_tmp_re;
  c1_tmp_re = 0.0 * a[2].re;
  c1_tmp_im = 0.0 * a[2].im;
  b_c1_tmp_re = 0.0 * a[1].re;
  b_c1_tmp_im = 0.0 * a[1].im;
  c2_tmp_re = 0.0 * a[0].re;
  c2_tmp_im = 0.0 * a[0].im;
  c[0].re = b_c1_tmp_re - c1_tmp_re;
  c[0].im = b_c1_tmp_im - c1_tmp_im;
  c[1].re = c1_tmp_re - c2_tmp_re;
  c[1].im = c1_tmp_im - c2_tmp_im;
  c[2].re = c2_tmp_re - b_c1_tmp_re;
  c[2].im = c2_tmp_im - b_c1_tmp_im;
}

/* End of code generation (cross.c) */
