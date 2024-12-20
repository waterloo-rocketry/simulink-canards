/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * model_f.c
 *
 * Code generation for function 'model_f'
 *
 */

/* Include files */
#include "model_f.h"
#include "ekf_algorithm_data.h"
#include "ekf_algorithm_rtwutil.h"
#include "eye.h"
#include "mtimes.h"
#include "norm.h"
#include "rt_nonfinite.h"
#include <emmintrin.h>
#include <math.h>

/* Function Definitions */
void model_f(const double x[13], const double u[4], double x_dot[13])
{
  static const double d_a[9] = {1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0};
  __m128d r;
  __m128d r1;
  __m128d r2;
  double dv2[16];
  double S[9];
  double b_dv[9];
  double q_tilde[9];
  double dv4[4];
  double layer[4];
  double b[3];
  double b_b[3];
  double b_dv1[3];
  double c_a[3];
  double dv3[3];
  double w_dot[3];
  double a;
  double alpha;
  double b_a;
  double beta;
  double d;
  double d1;
  double d2;
  double p_dyn;
  int S_tmp;
  int i;
  int i1;
  /*  time t is not used yet, but required by matlab ode syntax */
  /*  Computes state derivative with predictive model. Use ODE solver to compute
   * next state. */
  /*  decompose state vector: [q(4); w(3); v(3); alt; Cl; delta] */
  /*  decompose input vector: [delta_u(1), A(3)] */
  /*  get parameters */
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
  /*  compute rotational matrix (attitude transformation matrix, between body
   * frame and ground frame) */
  /*  computes rotation matrix from quaternion */
  /*  norm quaternions */
  r = _mm_set1_pd(1.0 / b_norm(&x[0]));
  _mm_storeu_pd(&layer[0], _mm_mul_pd(r, _mm_loadu_pd(&x[0])));
  _mm_storeu_pd(&layer[2], _mm_mul_pd(r, _mm_loadu_pd(&x[2])));
  /*  skew symetric quaternion matrix */
  q_tilde[0] = 0.0;
  q_tilde[3] = -layer[3];
  q_tilde[6] = layer[2];
  q_tilde[1] = layer[3];
  q_tilde[4] = 0.0;
  q_tilde[7] = -layer[1];
  q_tilde[2] = -layer[2];
  q_tilde[5] = layer[1];
  q_tilde[8] = 0.0;
  /*  rotation matrix */
  a = 2.0 * layer[0];
  eye(b_dv);
  for (i = 0; i < 3; i++) {
    for (i1 = 0; i1 < 3; i1++) {
      S_tmp = i + 3 * i1;
      S[S_tmp] = (b_dv[S_tmp] + a * q_tilde[S_tmp]) +
                 ((2.0 * q_tilde[i] * q_tilde[3 * i1] +
                   2.0 * q_tilde[i + 3] * q_tilde[3 * i1 + 1]) +
                  2.0 * q_tilde[i + 6] * q_tilde[3 * i1 + 2]);
    }
  }
  /*  calculate air data */
  /*  computes air data from altitude, according to US standard atmosphere  */
  /*  air data: static pressure, temperature, density, local speed of sound */
  /*  calculations found in Stengel 2004, pp. 30 */
  /*  geopotential altitude neglected, may (should) be added in */
  /*  get parameters */
  /*    %% Rocket body */
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
  /*  select atmosphere behaviour from table */
  if (x[10] < 20000.0) {
    layer[0] = 22632.1;
    layer[1] = 216.65;
    layer[2] = 0.0;
    layer[3] = 11000.0;
  } else if (x[10] < 32000.0) {
    layer[0] = 5474.9;
    layer[1] = 216.65;
    layer[2] = -0.001;
    layer[3] = 20000.0;
  } else if (x[10] >= 32000.0) {
    layer[0] = 868.02;
    layer[1] = 228.65;
    layer[2] = -0.0028;
    layer[3] = 32000.0;
  } else {
    layer[0] = 101325.0;
    layer[1] = 288.15;
    layer[2] = 0.0065;
    layer[3] = 0.0;
  }
  /*  base pressure */
  /*  base temperature */
  /*  temperature lapse rate */
  /*  base height */
  if (layer[2] == 0.0) {
    p_dyn = layer[0] *
            exp(-9.8 * (x[10] - layer[3]) / (287.05790556683377 * layer[1]));
  } else {
    p_dyn = layer[0] *
            rt_powd_snf(layer[1] / (layer[1] + layer[2] * (x[10] - layer[3])),
                        9.8 / (287.05790556683377 * layer[2]));
  }
  a = c_norm(&x[7]);
  /*  Ma = airspeed / mach_local; % remove if not needed */
  /*  alpha = atan2(v(2), v(1)); */
  /*  beta = atan2(v(3), v(1)); atan2 cannot handle complex numbers needed */
  /*  for jacobian function. Can use atan2 is jacobian is determined otherwise
   */
  if (x[7] != 0.0) {
    alpha = x[8] / x[7];
    /*  use small angle approx instead of atan2 */
    beta = x[9] / x[7];
  } else {
    alpha = 0.0;
    beta = 0.0;
  }
  p_dyn = p_dyn /
          (287.05790556683377 * (layer[1] - layer[2] * (x[10] - layer[3]))) /
          2.0 * (a * a);
  /*  forces (specific) */
  /*  torques */
  a = x[11] * 0.001266 * p_dyn * x[12];
  p_dyn *= -0.032429278662239852;
  /* %%%%%%%%%%%%%%%%%%%%%%%%%% derivatives */
  /*  quaternion derivatives */
  /*  computes quaternion derivative from quaternion and body rates */
  /*  norm quaternions */
  _mm_storeu_pd(&layer[0], _mm_mul_pd(r, _mm_loadu_pd(&x[0])));
  _mm_storeu_pd(&layer[2], _mm_mul_pd(r, _mm_loadu_pd(&x[2])));
  /*  angular rate matrix */
  /*  quaternion derivative */
  b_a = c_norm(&x[4]);
  /*  rate derivatives */
  d = x[4];
  d1 = x[5];
  d2 = x[6];
  r = _mm_loadu_pd(&dv[0]);
  r = _mm_mul_pd(r, _mm_set1_pd(d));
  r1 = _mm_loadu_pd(&dv[3]);
  r1 = _mm_mul_pd(r1, _mm_set1_pd(d1));
  r = _mm_add_pd(r, r1);
  r1 = _mm_loadu_pd(&dv[6]);
  r1 = _mm_mul_pd(r1, _mm_set1_pd(d2));
  r = _mm_add_pd(r, r1);
  _mm_storeu_pd(&b[0], r);
  b[2] = (dv[2] * d + dv[5] * d1) + dv[8] * d2;
  c_a[0] = (p_dyn * 0.0 + a) - (b[2] * x[5] - b[1] * x[6]);
  c_a[1] = (p_dyn * alpha + a * 0.0) - (b[0] * x[6] - b[2] * x[4]);
  c_a[2] = (p_dyn * beta + a * 0.0) - (b[1] * x[4] - b[0] * x[5]);
  /*  velocity derivatives  */
  /* %% acceleration specific force */
  /* %% use aerodynamic for simulation, acceleration for filter */
  /*  v_dot = force - cross(w,v) + S'*g; */
  /*  altitude derivative */
  /*  canard coefficients derivative , airfoil theory */
  /*  This turned out to be way to involved, setting the prediction to zero
   * change for now */
  /*  returns Cl to expected value slowly, to force convergence in EKF */
  /*  actuator dynamics */
  /*  linear 1st order */
  /*  concoct state derivative vector */
  b[0] = x[5] * 0.0 - 0.0 * x[6];
  b[1] = 0.0 * x[6] - x[4] * 0.0;
  b[2] = x[4] * 0.0 - 0.0 * x[5];
  mtimes(d_a, &u[1], b_dv1);
  dv2[0] = 0.0;
  d = c_a[0];
  d1 = c_a[1];
  d2 = c_a[2];
  for (i = 0; i < 3; i++) {
    w_dot[i] = (dv1[i] * d + dv1[i + 3] * d1) + dv1[i + 6] * d2;
    p_dyn = x[i + 4];
    dv2[(i + 1) << 2] = 0.5 * -p_dyn;
    dv2[i + 1] = 0.5 * p_dyn;
  }
  dv2[5] = -0.0;
  dv2[9] = 0.5 * x[6];
  dv2[13] = 0.5 * -x[5];
  dv2[6] = 0.5 * -x[6];
  dv2[10] = -0.0;
  dv2[14] = 0.5 * x[4];
  dv2[7] = 0.5 * x[5];
  dv2[11] = 0.5 * -x[4];
  dv2[15] = -0.0;
  dv3[0] = b_dv1[0] - (w_dot[1] * 0.0 - 0.0 * w_dot[2]);
  dv3[1] = b_dv1[1] - (0.0 * w_dot[2] - w_dot[0] * 0.0);
  dv3[2] = b_dv1[2] - (w_dot[0] * 0.0 - 0.0 * w_dot[1]);
  b_b[0] = b[2] * x[5] - b[1] * x[6];
  b_b[1] = b[0] * x[6] - b[2] * x[4];
  b_b[2] = b[1] * x[4] - b[0] * x[5];
  b_dv1[0] = 2.0 * (x[5] * x[9] - x[6] * x[8]);
  b_dv1[1] = 2.0 * (x[6] * x[7] - x[4] * x[9]);
  b_dv1[2] = 2.0 * (x[4] * x[8] - x[5] * x[7]);
  d = x[7];
  d1 = x[8];
  d2 = x[9];
  r = _mm_loadu_pd(&S[0]);
  r = _mm_mul_pd(r, _mm_set1_pd(d));
  r1 = _mm_loadu_pd(&S[3]);
  r1 = _mm_mul_pd(r1, _mm_set1_pd(d1));
  r = _mm_add_pd(r, r1);
  r1 = _mm_loadu_pd(&S[6]);
  r1 = _mm_mul_pd(r1, _mm_set1_pd(d2));
  r = _mm_add_pd(r, r1);
  _mm_storeu_pd(&c_a[0], r);
  for (i = 0; i <= 2; i += 2) {
    r = _mm_loadu_pd(&dv2[i]);
    r = _mm_mul_pd(r, _mm_set1_pd(layer[0]));
    r1 = _mm_loadu_pd(&dv2[i + 4]);
    r1 = _mm_mul_pd(r1, _mm_set1_pd(layer[1]));
    r = _mm_add_pd(r, r1);
    r1 = _mm_loadu_pd(&dv2[i + 8]);
    r1 = _mm_mul_pd(r1, _mm_set1_pd(layer[2]));
    r = _mm_add_pd(r, r1);
    r1 = _mm_loadu_pd(&dv2[i + 12]);
    r1 = _mm_mul_pd(r1, _mm_set1_pd(layer[3]));
    r = _mm_add_pd(r, r1);
    r1 = _mm_loadu_pd(&layer[i]);
    r2 = _mm_loadu_pd(&x[i]);
    r1 = _mm_sub_pd(r1, r2);
    r1 = _mm_mul_pd(_mm_set1_pd(b_a), r1);
    r = _mm_add_pd(r, r1);
    _mm_storeu_pd(&dv4[i], r);
  }
  for (i = 0; i < 3; i++) {
    b[i] = ((dv3[i] - b_b[i]) - b_dv1[i]) +
           ((S[3 * i] * -9.8 + S[3 * i + 1] * 0.0) + S[3 * i + 2] * 0.0);
  }
  x_dot[0] = dv4[0];
  x_dot[1] = dv4[1];
  x_dot[2] = dv4[2];
  x_dot[3] = dv4[3];
  x_dot[4] = w_dot[0];
  x_dot[7] = b[0];
  x_dot[5] = w_dot[1];
  x_dot[8] = b[1];
  x_dot[6] = w_dot[2];
  x_dot[9] = b[2];
  x_dot[10] = c_a[0];
  x_dot[11] = -100.0 * (x[11] - 1.5);
  x_dot[12] = -60.0 * x[12] + 60.0 * u[0];
}

/* End of code generation (model_f.c) */
