/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * mpower.c
 *
 * Code generation for function 'mpower'
 *
 */

/* Include files */
#include "mpower.h"
#include "atan2.h"
#include "ekf_algorithm_rtwutil.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
creal_T mpower(const creal_T a, double b)
{
  creal_T c;
  double b_b;
  double r;
  double ytmp;
  signed char i;
  boolean_T guard1;
  if ((a.im == 0.0) && (a.re >= 0.0)) {
    c.re = rt_powd_snf(a.re, b);
    c.im = 0.0;
  } else if ((a.re == 0.0) && (floor(b) == b)) {
    ytmp = rt_powd_snf(a.im, b);
    if (rtIsInf(b)) {
      r = rtNaN;
    } else if (b == 0.0) {
      r = 0.0;
    } else {
      r = fmod(b, 4.0);
      if (r == 0.0) {
        r = 0.0;
      } else if (r < 0.0) {
        r += 4.0;
      }
    }
    if (r < 128.0) {
      i = (signed char)r;
    } else {
      i = 0;
    }
    if (i == 3) {
      c.re = 0.0;
      c.im = -ytmp;
    } else if (i == 2) {
      c.re = -ytmp;
      c.im = 0.0;
    } else if (i == 1) {
      c.re = 0.0;
      c.im = ytmp;
    } else {
      c.re = ytmp;
      c.im = 0.0;
    }
  } else if ((a.im == 0.0) && rtIsInf(b) && (fabs(a.re) == 1.0)) {
    c.re = 1.0;
    c.im = 0.0;
  } else {
    if (a.im == 0.0) {
      if (a.re < 0.0) {
        ytmp = log(fabs(a.re));
        b_b = 3.1415926535897931;
      } else {
        ytmp = log(a.re);
        b_b = 0.0;
      }
    } else {
      ytmp = fabs(a.re);
      guard1 = false;
      if (ytmp > 8.9884656743115785E+307) {
        guard1 = true;
      } else {
        b_b = fabs(a.im);
        if (b_b > 8.9884656743115785E+307) {
          guard1 = true;
        } else {
          if (ytmp < b_b) {
            ytmp /= b_b;
            ytmp = b_b * sqrt(ytmp * ytmp + 1.0);
          } else if (ytmp > b_b) {
            b_b /= ytmp;
            ytmp *= sqrt(b_b * b_b + 1.0);
          } else if (rtIsNaN(b_b)) {
            ytmp = rtNaN;
          } else {
            ytmp *= 1.4142135623730951;
          }
          ytmp = log(ytmp);
          b_b = b_atan2(a.im, a.re);
        }
      }
      if (guard1) {
        ytmp = fabs(a.re / 2.0);
        b_b = fabs(a.im / 2.0);
        if (ytmp < b_b) {
          ytmp /= b_b;
          ytmp = b_b * sqrt(ytmp * ytmp + 1.0);
        } else if (ytmp > b_b) {
          b_b /= ytmp;
          ytmp *= sqrt(b_b * b_b + 1.0);
        } else if (rtIsNaN(b_b)) {
          ytmp = rtNaN;
        } else {
          ytmp *= 1.4142135623730951;
        }
        ytmp = log(ytmp) + 0.69314718055994529;
        b_b = b_atan2(a.im, a.re);
      }
    }
    ytmp *= b;
    b_b *= b;
    if (ytmp == 0.0) {
      c.re = cos(b_b);
      c.im = sin(b_b);
    } else if (b_b == 0.0) {
      c.re = exp(ytmp);
      c.im = 0.0;
    } else if (rtIsInf(b_b) && rtIsInf(ytmp) && (ytmp < 0.0)) {
      c.re = 0.0;
      c.im = 0.0;
    } else {
      r = exp(ytmp / 2.0);
      c.re = r * (r * cos(b_b));
      c.im = r * (r * sin(b_b));
    }
  }
  return c;
}

/* End of code generation (mpower.c) */
