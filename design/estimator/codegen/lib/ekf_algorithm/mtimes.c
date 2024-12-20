/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mtimes.c
 *
 * Code generation for function 'mtimes'
 *
 */

/* Include files */
#include "mtimes.h"
#include "rt_nonfinite.h"

/* Function Definitions */
void mtimes(const double A[9], const double B[3], double C[3])
{
  double d;
  double d1;
  double d2;
  int aoffset;
  int i;
  d = B[0];
  d1 = B[1];
  d2 = B[2];
  for (i = 0; i < 3; i++) {
    aoffset = i * 3;
    C[i] = (A[aoffset] * d + A[aoffset + 1] * d1) + A[aoffset + 2] * d2;
  }
}

/* End of code generation (mtimes.c) */
