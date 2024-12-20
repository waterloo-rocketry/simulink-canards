/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * ekf_algorithm.c
 *
 * Code generation for function 'ekf_algorithm'
 *
 */

/* Include files */
#include "ekf_algorithm.h"
#include "colon.h"
#include "ekf_algorithm_data.h"
#include "ekf_algorithm_emxutil.h"
#include "ekf_algorithm_initialize.h"
#include "ekf_algorithm_types.h"
#include "jacobian.h"
#include "ode45.h"
#include "rt_nonfinite.h"
#include "rt_nonfinite.h"
#include <emmintrin.h>
#include <math.h>

/* Function Definitions */
void ekf_algorithm(const double x[13], const double P[169], const double u[4],
                   const double y[8], double t, const double Q[169],
                   const double R[64], double T, double step, double x_new[13],
                   double P_new[169])
{
  __m128d r;
  __m128d r1;
  __m128d r2;
  __m128d r3;
  __m128d r4;
  emxArray_real_T *a__1;
  emxArray_real_T *b_y;
  emxArray_real_T *x_solver;
  double F1[169];
  double F2[169];
  double b_P[169];
  double c_P[169];
  double a;
  double d;
  double d1;
  double *y_data;
  int i;
  int i1;
  int i2;
  int loop_ub;
  (void)y;
  (void)t;
  (void)R;
  if (!isInitialized_ekf_algorithm) {
    ekf_algorithm_initialize();
  }
  /*  Computes EKF iteration. Uses model_f for prediction and model_h for
   * correction. */
  /*  use either this or ekf_predict and ekf_correct seperately */
  /*  Inputs: estimates x, P; control u; measurement y; timecode t */
  /*  Input parameters: weighting Q, R; time difference to last compute T; step
   * size for ODE solver step */
  /*  Outputs: new estimates x, P */
  /*     %% Prediction */
  /*  computes a-priori state and covariance estimates. */
  /*  Uses continuous-time model f and solves for state estimate using RK45 */
  /*  Solves for covariance estimate using Improved Euler */
  /*     %% Rocket body */
  /* mass in kg */
  /*  inertia roll */
  /*  inertia pitch, yaw */
  /*  center of gravity */
  /*  center of pressure */
  /*  cross section of body tube */
  /*  pitch coefficent  */
  /*  moment coefficient of body */
  /*  Sensors */
  /*  rotation transform from sensor frame to body frame */
  /*  center of sensor frame */
  /*  Canards, Actuator */
  /*  time constant of first order actuator dynamics */
  /*  estimated coefficient of lift, const with Ma */
  /*  time constant to converge Cl back to 1.5 in filter */
  /*  total canard area  */
  /*  lever arm of canard to x-axis  */
  /*  moment arm * area of canard */
  /*  Environment */
  /*  gravitational acceleration in the geographic inertial frame */
  /*  adiabatic index */
  /*  specific gas constant for air */
  /*  troposphere */
  /*  tropopause */
  /*  stratosphere */
  /*  stratopause */
  /*  P_base, T_base, lapse rate, base height; */
  /*  x_dot = model_f(x, u); */
  emxInit_real_T(&b_y, 2);
  if (rtIsNaN(step) || rtIsNaN(T)) {
    i = b_y->size[0] * b_y->size[1];
    b_y->size[0] = 1;
    b_y->size[1] = 1;
    emxEnsureCapacity_real_T(b_y, i);
    y_data = b_y->data;
    y_data[0] = rtNaN;
  } else if ((step == 0.0) || ((T > 0.0) && (step < 0.0)) ||
             ((T < 0.0) && (step > 0.0))) {
    b_y->size[0] = 1;
    b_y->size[1] = 0;
  } else if (rtIsInf(T) && rtIsInf(step)) {
    i = b_y->size[0] * b_y->size[1];
    b_y->size[0] = 1;
    b_y->size[1] = 1;
    emxEnsureCapacity_real_T(b_y, i);
    y_data = b_y->data;
    y_data[0] = rtNaN;
  } else if (rtIsInf(step)) {
    i = b_y->size[0] * b_y->size[1];
    b_y->size[0] = 1;
    b_y->size[1] = 1;
    emxEnsureCapacity_real_T(b_y, i);
    y_data = b_y->data;
    y_data[0] = 0.0;
  } else if (floor(step) == step) {
    i = b_y->size[0] * b_y->size[1];
    b_y->size[0] = 1;
    loop_ub = (int)(T / step);
    b_y->size[1] = loop_ub + 1;
    emxEnsureCapacity_real_T(b_y, i);
    y_data = b_y->data;
    for (i = 0; i <= loop_ub; i++) {
      y_data[i] = step * (double)i;
    }
  } else {
    eml_float_colon(step, T, b_y);
  }
  emxInit_real_T(&a__1, 1);
  emxInit_real_T(&x_solver, 2);
  ode45(u, b_y, x, a__1, x_solver);
  y_data = x_solver->data;
  emxFree_real_T(&b_y);
  emxFree_real_T(&a__1);
  /*  RK45 (DoPri) */
  for (i = 0; i < 13; i++) {
    x_new[i] = y_data[(x_solver->size[0] + x_solver->size[0] * i) - 1];
  }
  emxFree_real_T(&x_solver);
  /*  compute Jacobians (using complex-step differentiation) */
  jacobian(x, step, F1);
  jacobian(x_new, step, F2);
  /*  P_dot = F*P + P*F'+ Q */
  a = T / 2.0;
  for (i = 0; i < 13; i++) {
    for (i1 = 0; i1 < 13; i1++) {
      d = 0.0;
      d1 = 0.0;
      for (i2 = 0; i2 < 13; i2++) {
        loop_ub = i + 13 * i2;
        d += F1[loop_ub] * P[i2 + 13 * i1];
        d1 += P[loop_ub] * F1[i1 + 13 * i2];
      }
      loop_ub = i + 13 * i1;
      b_P[loop_ub] = d1;
      P_new[loop_ub] = d;
    }
  }
  for (i = 0; i < 13; i++) {
    for (i1 = 0; i1 < 13; i1++) {
      d = 0.0;
      d1 = 0.0;
      for (i2 = 0; i2 < 13; i2++) {
        loop_ub = i + 13 * i2;
        d += F2[loop_ub] * P[i2 + 13 * i1];
        d1 += P[loop_ub] * F2[i1 + 13 * i2];
      }
      loop_ub = i + 13 * i1;
      c_P[loop_ub] = d1;
      F1[loop_ub] = d;
    }
  }
  for (i = 0; i <= 166; i += 2) {
    r = _mm_loadu_pd(&P_new[i]);
    r1 = _mm_loadu_pd(&b_P[i]);
    r2 = _mm_loadu_pd(&Q[i]);
    r3 = _mm_loadu_pd(&F1[i]);
    r4 = _mm_loadu_pd(&c_P[i]);
    _mm_storeu_pd(
        &P_new[i],
        _mm_add_pd(_mm_loadu_pd(&P[i]),
                   _mm_mul_pd(_mm_set1_pd(a),
                              _mm_add_pd(_mm_add_pd(_mm_add_pd(r, r1), r2),
                                         _mm_add_pd(_mm_add_pd(r3, r4), r2)))));
  }
  P_new[168] = P[168] + a * (((P_new[168] + b_P[168]) + Q[168]) +
                             ((F1[168] + c_P[168]) + Q[168]));
  /*  improved Euler */
  /*     %% Correction */
  /*  computes a-posteriori state and covariance estimates. */
  /*  Uses discrete-time model h */
  /*  Solves for covariance estimate  */
  /*  compute expected measurement and difference to measured values */
  /*  compute Jacobians (here using closed-form solution) */
  /*  Computes the Jacobian matrix of a vector function using complex-step
   * differentiation */
  /*  Inputs: ODE function f, time t, state x, step size h */
  /*  Outputs: Jacobian matrix del_f/del_x */
  /*  size of input */
  /*  size of output */
  /*  prep Jacobian array */
  /*  compute Kalman gain */
  /*  correct state and covariance estimates */
}

/* End of code generation (ekf_algorithm.c) */
