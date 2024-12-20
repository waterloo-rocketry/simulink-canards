/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ode45.c
 *
 * Code generation for function 'ode45'
 *
 */

/* Include files */
#include "ode45.h"
#include "ekf_algorithm_emxutil.h"
#include "ekf_algorithm_rtwutil.h"
#include "ekf_algorithm_types.h"
#include "model_f.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <math.h>
#include <string.h>

/* Function Declarations */
static int div_nde_s32_floor(int numerator);

/* Function Definitions */
static int div_nde_s32_floor(int numerator)
{
  int quotient;
  if ((numerator < 0) && (numerator % 13 != 0)) {
    quotient = -1;
  } else {
    quotient = 0;
  }
  quotient += numerator / 13;
  return quotient;
}

void ode45(const double ode_workspace_u[4], const emxArray_real_T *tspan,
           const double b_y0[13], emxArray_real_T *varargout_1,
           emxArray_real_T *varargout_2)
{
  static const double x[21] = {0.2,
                               0.075,
                               0.225,
                               0.97777777777777775,
                               -3.7333333333333334,
                               3.5555555555555554,
                               2.9525986892242035,
                               -11.595793324188385,
                               9.8228928516994358,
                               -0.29080932784636487,
                               2.8462752525252526,
                               -10.757575757575758,
                               8.9064227177434727,
                               0.27840909090909088,
                               -0.2735313036020583,
                               0.091145833333333329,
                               0.0,
                               0.44923629829290207,
                               0.65104166666666663,
                               -0.322376179245283,
                               0.13095238095238096};
  static const double b[7] = {0.0012326388888888888,
                              0.0,
                              -0.0042527702905061394,
                              0.036979166666666667,
                              -0.05086379716981132,
                              0.0419047619047619,
                              -0.025};
  static const double b_b[7] = {-2.859375,
                                0.0,
                                4.0431266846361185,
                                -3.90625,
                                2.7939268867924527,
                                -1.5714285714285714,
                                1.5};
  static const double c_b[7] = {3.0833333333333335,
                                0.0,
                                -6.2893081761006293,
                                10.416666666666666,
                                -6.8773584905660377,
                                3.6666666666666665,
                                -4.0};
  static const double d_b[7] = {-1.1328125,
                                0.0,
                                2.6954177897574123,
                                -5.859375,
                                3.7610554245283021,
                                -1.9642857142857142,
                                2.5};
  emxArray_real_T *tout;
  emxArray_real_T *yout;
  double f[91];
  double f0[13];
  double y[13];
  double ynew[13];
  const double *tspan_data;
  double absh;
  double absx;
  double b_d1;
  double d;
  double d1;
  double err;
  double h;
  double hmax;
  double hmin;
  double t;
  double tdir;
  double tfinal_tmp;
  double tnew;
  double twidth;
  double *tout_data;
  double *varargout_1_data;
  double *yout_data;
  int Bcolidx;
  int b_k;
  int exitg1;
  int exitg2;
  int exponent;
  int i;
  int ia;
  int iac;
  int k;
  int next;
  int nnxt;
  int nout;
  boolean_T Done;
  boolean_T MinStepExit;
  boolean_T NoFailedAttempts;
  tspan_data = tspan->data;
  tfinal_tmp = tspan_data[tspan->size[1] - 1];
  model_f(b_y0, ode_workspace_u, f0);
  emxInit_real_T(&tout, 2);
  i = tout->size[0] * tout->size[1];
  tout->size[0] = 1;
  nnxt = tspan->size[1];
  tout->size[1] = tspan->size[1];
  emxEnsureCapacity_real_T(tout, i);
  tout_data = tout->data;
  for (i = 0; i < nnxt; i++) {
    tout_data[i] = 0.0;
  }
  emxInit_real_T(&yout, 2);
  i = yout->size[0] * yout->size[1];
  yout->size[0] = 13;
  yout->size[1] = tspan->size[1];
  emxEnsureCapacity_real_T(yout, i);
  yout_data = yout->data;
  nnxt = 13 * tspan->size[1];
  for (i = 0; i < nnxt; i++) {
    yout_data[i] = 0.0;
  }
  nout = 1;
  tout_data[0] = tspan_data[0];
  for (i = 0; i < 13; i++) {
    yout_data[i] = b_y0[i];
  }
  tdir = tfinal_tmp - tspan_data[0];
  twidth = fabs(tdir);
  d1 = fabs(tspan_data[0]);
  d = fabs(tfinal_tmp);
  if ((d1 >= d) || rtIsNaN(d)) {
    d = d1;
  }
  d *= 3.5527136788005009E-15;
  absx = 0.1 * twidth;
  if ((absx >= d) || rtIsNaN(d)) {
    d = absx;
  }
  if ((twidth <= d) || rtIsNaN(d)) {
    hmax = twidth;
  } else {
    hmax = d;
  }
  if (rtIsInf(d1) || rtIsNaN(d1)) {
    twidth = rtNaN;
  } else if (d1 < 4.4501477170144028E-308) {
    twidth = 4.94065645841247E-324;
  } else {
    frexp(d1, &Bcolidx);
    twidth = ldexp(1.0, Bcolidx - 53);
  }
  d = 16.0 * twidth;
  twidth = fabs(tspan_data[1] - tspan_data[0]);
  if ((hmax <= twidth) || rtIsNaN(twidth)) {
    absh = hmax;
  } else {
    absh = twidth;
  }
  twidth = 0.0;
  for (k = 0; k < 13; k++) {
    b_d1 = fabs(b_y0[k]);
    if (!(b_d1 >= 0.001)) {
      b_d1 = 0.001;
    }
    absx = fabs(f0[k] / b_d1);
    if (rtIsNaN(absx) || (absx > twidth)) {
      twidth = absx;
    }
  }
  twidth /= 0.20095091452076641;
  if (absh * twidth > 1.0) {
    absh = 1.0 / twidth;
  }
  if ((!(absh >= d)) && (!rtIsNaN(d))) {
    absh = d;
  }
  t = tspan_data[0];
  memcpy(&y[0], &b_y0[0], 13U * sizeof(double));
  memset(&f[0], 0, 91U * sizeof(double));
  memcpy(&f[0], &f0[0], 13U * sizeof(double));
  if (!rtIsNaN(tdir)) {
    if (tdir < 0.0) {
      tdir = -1.0;
    } else {
      tdir = (tdir > 0.0);
    }
  }
  next = 0;
  MinStepExit = false;
  Done = false;
  do {
    exitg1 = 0;
    absx = fabs(t);
    if (rtIsInf(absx) || rtIsNaN(absx)) {
      twidth = rtNaN;
    } else if (absx < 4.4501477170144028E-308) {
      twidth = 4.94065645841247E-324;
    } else {
      frexp(absx, &exponent);
      twidth = ldexp(1.0, exponent - 53);
    }
    hmin = 16.0 * twidth;
    if ((hmin >= absh) || rtIsNaN(absh)) {
      d = hmin;
    } else {
      d = absh;
    }
    if ((hmax <= d) || rtIsNaN(d)) {
      absh = hmax;
    } else {
      absh = d;
    }
    h = tdir * absh;
    b_d1 = tfinal_tmp - t;
    d = fabs(b_d1);
    if (1.1 * absh >= d) {
      h = b_d1;
      absh = d;
      Done = true;
    }
    NoFailedAttempts = true;
    do {
      exitg2 = 0;
      Bcolidx = 0;
      for (k = 0; k < 5; k++) {
        Bcolidx += k;
        memcpy(&f0[0], &y[0], 13U * sizeof(double));
        if (!(h == 0.0)) {
          i = 13 * k + 1;
          for (iac = 1; iac <= i; iac += 13) {
            twidth = h * x[Bcolidx + div_nde_s32_floor(iac - 1)];
            b_k = iac + 12;
            for (ia = iac; ia <= b_k; ia++) {
              nnxt = ia - iac;
              f0[nnxt] += f[ia - 1] * twidth;
            }
          }
        }
        model_f(f0, ode_workspace_u, &f[13 * (k + 1)]);
      }
      tnew = t + h;
      memcpy(&ynew[0], &y[0], 13U * sizeof(double));
      if (!(h == 0.0)) {
        for (iac = 0; iac <= 65; iac += 13) {
          twidth = h * x[(Bcolidx + div_nde_s32_floor(iac)) + 5];
          i = iac + 13;
          for (ia = iac + 1; ia <= i; ia++) {
            nnxt = (ia - iac) - 1;
            ynew[nnxt] += f[ia - 1] * twidth;
          }
        }
      }
      model_f(ynew, ode_workspace_u, &f[78]);
      for (i = 0; i < 13; i++) {
        b_d1 = 0.0;
        for (b_k = 0; b_k < 7; b_k++) {
          b_d1 += f[i + 13 * b_k] * b[b_k];
        }
        f0[i] = b_d1;
      }
      if (Done) {
        tnew = tfinal_tmp;
      }
      h = tnew - t;
      d = 0.0;
      for (k = 0; k < 13; k++) {
        twidth = fabs(f0[k]);
        d1 = fabs(y[k]);
        absx = fabs(ynew[k]);
        if ((d1 > absx) || rtIsNaN(absx)) {
          if (d1 > 0.001) {
            twidth /= d1;
          } else {
            twidth /= 0.001;
          }
        } else if (absx > 0.001) {
          twidth /= absx;
        } else {
          twidth /= 0.001;
        }
        if ((twidth > d) || rtIsNaN(twidth)) {
          d = twidth;
        }
      }
      err = absh * d;
      if (!(err <= 0.001)) {
        if (absh <= hmin) {
          MinStepExit = true;
          exitg2 = 1;
        } else {
          if (NoFailedAttempts) {
            NoFailedAttempts = false;
            d = 0.8 * rt_powd_snf(0.001 / err, 0.2);
            if ((d <= 0.1) || rtIsNaN(d)) {
              d = 0.1;
            }
            d *= absh;
            if ((hmin >= d) || rtIsNaN(d)) {
              absh = hmin;
            } else {
              absh = d;
            }
          } else {
            d = 0.5 * absh;
            if ((hmin >= d) || rtIsNaN(d)) {
              absh = hmin;
            } else {
              absh = d;
            }
          }
          h = tdir * absh;
          Done = false;
        }
      } else {
        exitg2 = 1;
      }
    } while (exitg2 == 0);
    if (MinStepExit) {
      exitg1 = 1;
    } else {
      nnxt = next;
      while ((nnxt + 2 <= tspan->size[1]) &&
             (tdir * (tnew - tspan_data[nnxt + 1]) >= 0.0)) {
        nnxt++;
      }
      Bcolidx = nnxt - next;
      if (Bcolidx > 0) {
        for (k = next + 2; k <= nnxt; k++) {
          b_d1 = tspan_data[k - 1];
          tout_data[k - 1] = b_d1;
          twidth = (b_d1 - t) / h;
          for (b_k = 0; b_k < 13; b_k++) {
            b_d1 = 0.0;
            d = 0.0;
            absx = 0.0;
            for (i = 0; i < 7; i++) {
              d1 = f[b_k + 13 * i];
              b_d1 += d1 * (h * b_b[i]);
              d += d1 * (h * c_b[i]);
              absx += d1 * (h * d_b[i]);
            }
            yout_data[b_k + 13 * (k - 1)] =
                (((absx * twidth + d) * twidth + b_d1) * twidth + f[b_k] * h) *
                    twidth +
                y[b_k];
          }
        }
        tout_data[nnxt] = tspan_data[nnxt];
        if (tspan_data[nnxt] == tnew) {
          for (i = 0; i < 13; i++) {
            yout_data[i + 13 * nnxt] = ynew[i];
          }
        } else {
          twidth = (tspan_data[nnxt] - t) / h;
          for (k = 0; k < 13; k++) {
            b_d1 = 0.0;
            d = 0.0;
            absx = 0.0;
            for (i = 0; i < 7; i++) {
              d1 = f[k + 13 * i];
              b_d1 += d1 * (h * b_b[i]);
              d += d1 * (h * c_b[i]);
              absx += d1 * (h * d_b[i]);
            }
            yout_data[k + 13 * nnxt] =
                (((absx * twidth + d) * twidth + b_d1) * twidth + f[k] * h) *
                    twidth +
                y[k];
          }
        }
        nout += Bcolidx;
        next = nnxt;
      }
      if (Done) {
        exitg1 = 1;
      } else {
        if (NoFailedAttempts) {
          twidth = 1.25 * rt_powd_snf(err / 0.001, 0.2);
          if (twidth > 0.2) {
            absh /= twidth;
          } else {
            absh *= 5.0;
          }
        }
        t = tnew;
        for (nnxt = 0; nnxt < 13; nnxt++) {
          y[nnxt] = ynew[nnxt];
          f[nnxt] = f[nnxt + 78];
        }
      }
    }
  } while (exitg1 == 0);
  i = varargout_1->size[0];
  varargout_1->size[0] = nout;
  emxEnsureCapacity_real_T(varargout_1, i);
  varargout_1_data = varargout_1->data;
  for (i = 0; i < nout; i++) {
    varargout_1_data[i] = tout_data[i];
  }
  emxFree_real_T(&tout);
  i = varargout_2->size[0] * varargout_2->size[1];
  varargout_2->size[0] = nout;
  varargout_2->size[1] = 13;
  emxEnsureCapacity_real_T(varargout_2, i);
  varargout_1_data = varargout_2->data;
  for (i = 0; i < 13; i++) {
    for (b_k = 0; b_k < nout; b_k++) {
      varargout_1_data[b_k + varargout_2->size[0] * i] =
          yout_data[i + 13 * b_k];
    }
  }
  emxFree_real_T(&yout);
}

/* End of code generation (ode45.c) */
