/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * jacobian.c
 *
 * Code generation for function 'jacobian'
 *
 */

/* Include files */
#include "jacobian.h"
#include "cross.h"
#include "ekf_algorithm_data.h"
#include "exp.h"
#include "eye.h"
#include "mpower.h"
#include "norm.h"
#include "rt_nonfinite.h"
#include <math.h>

/* Function Definitions */
void jacobian(const double x[13], double h, double Jx[169])
{
  static const double dv3[3] = {-9.8, 0.0, 0.0};
  creal_T dcv1[16];
  creal_T b_x[13];
  creal_T S[9];
  creal_T q_tilde[9];
  creal_T q[4];
  creal_T b[3];
  creal_T b_S[3];
  creal_T b_b[3];
  creal_T dcv[3];
  creal_T p_dyn[3];
  creal_T w_dot[3];
  creal_T b_p_dyn;
  double b_dv[9];
  double b_dv1[4];
  double dv2[3];
  double a;
  double a_tmp;
  double alpha_im;
  double alpha_re;
  double beta_im;
  double beta_re;
  double d;
  double d1;
  double d2;
  double im;
  double layer_idx_0;
  double layer_idx_1;
  double layer_idx_2;
  double p_dyn_re;
  double re;
  double sgnbr;
  double torque_canards_im;
  double torque_canards_re;
  double x_re;
  int S_re_tmp;
  int b_i;
  int i;
  int k;
  signed char one[13];
  /*  Computes the Jacobian matrix of a vector function using complex-step
   * differentiation */
  /*  Inputs: ODE function f, time t, state x, step size h */
  /*  Outputs: Jacobian matrix del_f/del_x */
  /*  size of input */
  /*  size of output */
  /*  prep Jacobian array */
  eye(b_dv);
  dcv1[0].re = 0.0;
  dcv1[0].im = 0.0;
  dcv1[5].re = 0.0;
  dcv1[5].im = 0.0;
  dcv1[10].re = 0.0;
  dcv1[10].im = 0.0;
  dcv1[15].re = 0.0;
  dcv1[15].im = 0.0;
  for (k = 0; k < 13; k++) {
    for (i = 0; i < 13; i++) {
      one[i] = 0;
    }
    one[k] = 1;
    b_p_dyn.re = h * 0.0;
    for (i = 0; i < 13; i++) {
      b_i = one[i];
      b_x[i].re = x[i] + b_p_dyn.re * (double)b_i;
      b_x[i].im = h * (double)b_i;
    }
    /*  time t is not used yet, but required by matlab ode syntax */
    /*  Computes state derivative with predictive model. Use ODE solver to
     * compute next state. */
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
    a_tmp = 1.0 / d_norm(&b_x[0]);
    q[1].re = a_tmp * b_x[1].re;
    q[1].im = a_tmp * b_x[1].im;
    q[2].re = a_tmp * b_x[2].re;
    q[2].im = a_tmp * b_x[2].im;
    q[3].re = a_tmp * b_x[3].re;
    q[3].im = a_tmp * b_x[3].im;
    /*  skew symetric quaternion matrix */
    q_tilde[0].re = 0.0;
    q_tilde[0].im = 0.0;
    q_tilde[3].re = -q[3].re;
    q_tilde[3].im = -q[3].im;
    q_tilde[6] = q[2];
    q_tilde[1] = q[3];
    q_tilde[4].re = 0.0;
    q_tilde[4].im = 0.0;
    q_tilde[7].re = -q[1].re;
    q_tilde[7].im = -q[1].im;
    q_tilde[2].re = -q[2].re;
    q_tilde[2].im = -q[2].im;
    q_tilde[5] = q[1];
    q_tilde[8].re = 0.0;
    q_tilde[8].im = 0.0;
    /*  rotation matrix */
    b_p_dyn.re = 2.0 * (a_tmp * b_x[0].re);
    b_p_dyn.im = 2.0 * (a_tmp * b_x[0].im);
    for (b_i = 0; b_i < 3; b_i++) {
      for (S_re_tmp = 0; S_re_tmp < 3; S_re_tmp++) {
        re = 2.0 * q_tilde[b_i].re;
        layer_idx_2 = 2.0 * q_tilde[b_i].im;
        x_re = q_tilde[3 * S_re_tmp].im;
        p_dyn_re = q_tilde[3 * S_re_tmp].re;
        layer_idx_0 = re * p_dyn_re - layer_idx_2 * x_re;
        im = re * x_re + layer_idx_2 * p_dyn_re;
        re = 2.0 * q_tilde[b_i + 3].re;
        layer_idx_2 = 2.0 * q_tilde[b_i + 3].im;
        i = 3 * S_re_tmp + 1;
        x_re = q_tilde[i].im;
        p_dyn_re = q_tilde[i].re;
        layer_idx_0 += re * p_dyn_re - layer_idx_2 * x_re;
        im += re * x_re + layer_idx_2 * p_dyn_re;
        re = 2.0 * q_tilde[b_i + 6].re;
        layer_idx_2 = 2.0 * q_tilde[b_i + 6].im;
        i = 3 * S_re_tmp + 2;
        x_re = q_tilde[i].im;
        p_dyn_re = q_tilde[i].re;
        layer_idx_0 += re * p_dyn_re - layer_idx_2 * x_re;
        im += re * x_re + layer_idx_2 * p_dyn_re;
        i = b_i + 3 * S_re_tmp;
        re = q_tilde[i].im;
        layer_idx_2 = q_tilde[i].re;
        S[i].re = (b_dv[i] + (b_p_dyn.re * layer_idx_2 - b_p_dyn.im * re)) +
                  layer_idx_0;
        S[i].im = (b_p_dyn.re * re + b_p_dyn.im * layer_idx_2) + im;
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
    if (b_x[10].re < 20000.0) {
      layer_idx_0 = 22632.1;
      layer_idx_1 = 216.65;
      layer_idx_2 = 0.0;
      i = 11000;
    } else if (b_x[10].re < 32000.0) {
      layer_idx_0 = 5474.9;
      layer_idx_1 = 216.65;
      layer_idx_2 = -0.001;
      i = 20000;
    } else if (b_x[10].re >= 32000.0) {
      layer_idx_0 = 868.02;
      layer_idx_1 = 228.65;
      layer_idx_2 = -0.0028;
      i = 32000;
    } else {
      layer_idx_0 = 101325.0;
      layer_idx_1 = 288.15;
      layer_idx_2 = 0.0065;
      i = 0;
    }
    /*  base pressure */
    /*  base temperature */
    /*  temperature lapse rate */
    /*  base height */
    re = b_x[10].re - (double)i;
    torque_canards_re = layer_idx_2 * re;
    torque_canards_im = layer_idx_2 * b_x[10].im;
    if (layer_idx_2 == 0.0) {
      re *= -9.8;
      layer_idx_2 = -9.8 * b_x[10].im;
      im = 287.05790556683377 * layer_idx_1;
      if (layer_idx_2 == 0.0) {
        b_p_dyn.re = re / im;
        b_p_dyn.im = 0.0;
      } else if (re == 0.0) {
        b_p_dyn.re = 0.0;
        b_p_dyn.im = layer_idx_2 / im;
      } else {
        b_p_dyn.re = re / im;
        b_p_dyn.im = layer_idx_2 / im;
      }
      b_exp(&b_p_dyn);
      b_p_dyn.re *= layer_idx_0;
      b_p_dyn.im *= layer_idx_0;
    } else {
      im = layer_idx_1 + torque_canards_re;
      if (torque_canards_im == 0.0) {
        b_p_dyn.re = layer_idx_1 / im;
        b_p_dyn.im = 0.0;
      } else if (im == 0.0) {
        b_p_dyn.re = 0.0;
        b_p_dyn.im = -(layer_idx_1 / torque_canards_im);
      } else {
        x_re = fabs(im);
        p_dyn_re = fabs(torque_canards_im);
        if (x_re > p_dyn_re) {
          x_re = torque_canards_im / im;
          im += x_re * torque_canards_im;
          b_p_dyn.re = (layer_idx_1 + x_re * 0.0) / im;
          b_p_dyn.im = (0.0 - x_re * layer_idx_1) / im;
        } else if (p_dyn_re == x_re) {
          if (im > 0.0) {
            sgnbr = 0.5;
          } else {
            sgnbr = -0.5;
          }
          if (torque_canards_im > 0.0) {
            im = 0.5;
          } else {
            im = -0.5;
          }
          b_p_dyn.re = (layer_idx_1 * sgnbr + 0.0 * im) / x_re;
          b_p_dyn.im = (0.0 * sgnbr - layer_idx_1 * im) / x_re;
        } else {
          x_re = im / torque_canards_im;
          im = torque_canards_im + x_re * im;
          b_p_dyn.re = x_re * layer_idx_1 / im;
          b_p_dyn.im = (x_re * 0.0 - layer_idx_1) / im;
        }
      }
      b_p_dyn = mpower(b_p_dyn, 9.8 / (287.05790556683377 * layer_idx_2));
      b_p_dyn.re *= layer_idx_0;
      b_p_dyn.im *= layer_idx_0;
    }
    a = e_norm(&b_x[7]);
    /*  Ma = airspeed / mach_local; % remove if not needed */
    /*  alpha = atan2(v(2), v(1)); */
    /*  beta = atan2(v(3), v(1)); atan2 cannot handle complex numbers needed */
    /*  for jacobian function. Can use atan2 is jacobian is determined otherwise
     */
    if ((b_x[7].re != 0.0) || (b_x[7].im != 0.0)) {
      if (b_x[7].im == 0.0) {
        if (b_x[8].im == 0.0) {
          alpha_re = b_x[8].re / b_x[7].re;
          alpha_im = 0.0;
        } else if (b_x[8].re == 0.0) {
          alpha_re = 0.0;
          alpha_im = b_x[8].im / b_x[7].re;
        } else {
          alpha_re = b_x[8].re / b_x[7].re;
          alpha_im = b_x[8].im / b_x[7].re;
        }
        if (b_x[9].im == 0.0) {
          beta_re = b_x[9].re / b_x[7].re;
          beta_im = 0.0;
        } else if (b_x[9].re == 0.0) {
          beta_re = 0.0;
          beta_im = b_x[9].im / b_x[7].re;
        } else {
          beta_re = b_x[9].re / b_x[7].re;
          beta_im = b_x[9].im / b_x[7].re;
        }
      } else if (b_x[7].re == 0.0) {
        if (b_x[8].re == 0.0) {
          alpha_re = b_x[8].im / b_x[7].im;
          alpha_im = 0.0;
        } else if (b_x[8].im == 0.0) {
          alpha_re = 0.0;
          alpha_im = -(b_x[8].re / b_x[7].im);
        } else {
          alpha_re = b_x[8].im / b_x[7].im;
          alpha_im = -(b_x[8].re / b_x[7].im);
        }
        if (b_x[9].re == 0.0) {
          beta_re = b_x[9].im / b_x[7].im;
          beta_im = 0.0;
        } else if (b_x[9].im == 0.0) {
          beta_re = 0.0;
          beta_im = -(b_x[9].re / b_x[7].im);
        } else {
          beta_re = b_x[9].im / b_x[7].im;
          beta_im = -(b_x[9].re / b_x[7].im);
        }
      } else {
        p_dyn_re = fabs(b_x[7].re);
        re = fabs(b_x[7].im);
        if (p_dyn_re > re) {
          x_re = b_x[7].im / b_x[7].re;
          im = b_x[7].re + x_re * b_x[7].im;
          alpha_re = (b_x[8].re + x_re * b_x[8].im) / im;
          alpha_im = (b_x[8].im - x_re * b_x[8].re) / im;
          x_re = b_x[7].im / b_x[7].re;
          im = b_x[7].re + x_re * b_x[7].im;
          beta_re = (b_x[9].re + x_re * b_x[9].im) / im;
          beta_im = (b_x[9].im - x_re * b_x[9].re) / im;
        } else if (re == p_dyn_re) {
          if (b_x[7].re > 0.0) {
            sgnbr = 0.5;
          } else {
            sgnbr = -0.5;
          }
          if (b_x[7].im > 0.0) {
            im = 0.5;
          } else {
            im = -0.5;
          }
          alpha_re = (b_x[8].re * sgnbr + b_x[8].im * im) / p_dyn_re;
          alpha_im = (b_x[8].im * sgnbr - b_x[8].re * im) / p_dyn_re;
          if (b_x[7].re > 0.0) {
            sgnbr = 0.5;
          } else {
            sgnbr = -0.5;
          }
          if (b_x[7].im > 0.0) {
            im = 0.5;
          } else {
            im = -0.5;
          }
          beta_re = (b_x[9].re * sgnbr + b_x[9].im * im) / p_dyn_re;
          beta_im = (b_x[9].im * sgnbr - b_x[9].re * im) / p_dyn_re;
        } else {
          x_re = b_x[7].re / b_x[7].im;
          im = b_x[7].im + x_re * b_x[7].re;
          alpha_re = (x_re * b_x[8].re + b_x[8].im) / im;
          alpha_im = (x_re * b_x[8].im - b_x[8].re) / im;
          x_re = b_x[7].re / b_x[7].im;
          im = b_x[7].im + x_re * b_x[7].re;
          beta_re = (x_re * b_x[9].re + b_x[9].im) / im;
          beta_im = (x_re * b_x[9].im - b_x[9].re) / im;
        }
      }
      /*  use small angle approx instead of atan2 */
    } else {
      alpha_re = 0.0;
      alpha_im = 0.0;
      beta_re = 0.0;
      beta_im = 0.0;
    }
    im = 287.05790556683377 * (layer_idx_1 - torque_canards_re);
    re = 287.05790556683377 * (0.0 - torque_canards_im);
    if (re == 0.0) {
      if (b_p_dyn.im == 0.0) {
        p_dyn_re = b_p_dyn.re / im;
        layer_idx_2 = 0.0;
      } else if (b_p_dyn.re == 0.0) {
        p_dyn_re = 0.0;
        layer_idx_2 = b_p_dyn.im / im;
      } else {
        p_dyn_re = b_p_dyn.re / im;
        layer_idx_2 = b_p_dyn.im / im;
      }
    } else if (im == 0.0) {
      if (b_p_dyn.re == 0.0) {
        p_dyn_re = b_p_dyn.im / re;
        layer_idx_2 = 0.0;
      } else if (b_p_dyn.im == 0.0) {
        p_dyn_re = 0.0;
        layer_idx_2 = -(b_p_dyn.re / re);
      } else {
        p_dyn_re = b_p_dyn.im / re;
        layer_idx_2 = -(b_p_dyn.re / re);
      }
    } else {
      x_re = fabs(im);
      p_dyn_re = fabs(re);
      if (x_re > p_dyn_re) {
        x_re = re / im;
        im += x_re * re;
        p_dyn_re = (b_p_dyn.re + x_re * b_p_dyn.im) / im;
        layer_idx_2 = (b_p_dyn.im - x_re * b_p_dyn.re) / im;
      } else if (p_dyn_re == x_re) {
        if (im > 0.0) {
          sgnbr = 0.5;
        } else {
          sgnbr = -0.5;
        }
        if (re > 0.0) {
          im = 0.5;
        } else {
          im = -0.5;
        }
        p_dyn_re = (b_p_dyn.re * sgnbr + b_p_dyn.im * im) / x_re;
        layer_idx_2 = (b_p_dyn.im * sgnbr - b_p_dyn.re * im) / x_re;
      } else {
        x_re = im / re;
        im = re + x_re * im;
        p_dyn_re = (x_re * b_p_dyn.re + b_p_dyn.im) / im;
        layer_idx_2 = (x_re * b_p_dyn.im - b_p_dyn.re) / im;
      }
    }
    if (layer_idx_2 == 0.0) {
      p_dyn_re /= 2.0;
      layer_idx_2 = 0.0;
    } else if (p_dyn_re == 0.0) {
      p_dyn_re = 0.0;
      layer_idx_2 /= 2.0;
    } else {
      p_dyn_re /= 2.0;
      layer_idx_2 /= 2.0;
    }
    re = a * a;
    b_p_dyn.re = re * p_dyn_re;
    b_p_dyn.im = re * layer_idx_2;
    /*  forces (specific) */
    /*  torques */
    re = 0.001266 * b_x[11].re;
    layer_idx_2 = 0.001266 * b_x[11].im;
    x_re = re * b_p_dyn.re - layer_idx_2 * b_p_dyn.im;
    layer_idx_2 = re * b_p_dyn.im + layer_idx_2 * b_p_dyn.re;
    torque_canards_re = x_re * b_x[12].re - layer_idx_2 * b_x[12].im;
    torque_canards_im = x_re * b_x[12].im + layer_idx_2 * b_x[12].re;
    b_p_dyn.re *= -0.032429278662239852;
    b_p_dyn.im *= -0.032429278662239852;
    /* %%%%%%%%%%%%%%%%%%%%%%%%%% derivatives */
    /*  quaternion derivatives */
    /*  computes quaternion derivative from quaternion and body rates */
    /*  norm quaternions */
    q[0].re = a_tmp * b_x[0].re;
    q[0].im = a_tmp * b_x[0].im;
    q[1].re = a_tmp * b_x[1].re;
    q[1].im = a_tmp * b_x[1].im;
    q[2].re = a_tmp * b_x[2].re;
    q[2].im = a_tmp * b_x[2].im;
    q[3].re = a_tmp * b_x[3].re;
    q[3].im = a_tmp * b_x[3].im;
    /*  angular rate matrix */
    /*  quaternion derivative */
    a = e_norm(&b_x[4]);
    /*  rate derivatives */
    for (b_i = 0; b_i < 9; b_i++) {
      q_tilde[b_i].re = dv[b_i];
      q_tilde[b_i].im = 0.0;
    }
    sgnbr = b_x[4].re;
    layer_idx_1 = b_x[4].im;
    a_tmp = b_x[5].re;
    d = b_x[5].im;
    d1 = b_x[6].re;
    d2 = b_x[6].im;
    for (b_i = 0; b_i < 3; b_i++) {
      re = q_tilde[b_i].re;
      im = q_tilde[b_i].im;
      x_re = q_tilde[b_i + 3].re;
      layer_idx_2 = q_tilde[b_i + 3].im;
      p_dyn_re = q_tilde[b_i + 6].re;
      layer_idx_0 = q_tilde[b_i + 6].im;
      b[b_i].re =
          ((re * sgnbr - im * layer_idx_1) + (x_re * a_tmp - layer_idx_2 * d)) +
          (p_dyn_re * d1 - layer_idx_0 * d2);
      b[b_i].im =
          ((re * layer_idx_1 + im * sgnbr) + (x_re * d + layer_idx_2 * a_tmp)) +
          (p_dyn_re * d2 + layer_idx_0 * d1);
    }
    sgnbr = b_p_dyn.re * 0.0;
    layer_idx_1 = b_p_dyn.im * 0.0;
    for (b_i = 0; b_i < 9; b_i++) {
      q_tilde[b_i].re = dv1[b_i];
      q_tilde[b_i].im = 0.0;
    }
    a_tmp = ((sgnbr - layer_idx_1) + torque_canards_re) -
            ((b[2].re * b_x[5].re - b[2].im * b_x[5].im) -
             (b[1].re * b_x[6].re - b[1].im * b_x[6].im));
    sgnbr = ((sgnbr + layer_idx_1) + torque_canards_im) -
            ((b[2].re * b_x[5].im + b[2].im * b_x[5].re) -
             (b[1].re * b_x[6].im + b[1].im * b_x[6].re));
    layer_idx_1 = ((b_p_dyn.re * alpha_re - b_p_dyn.im * alpha_im) +
                   torque_canards_re * 0.0) -
                  ((b[0].re * b_x[6].re - b[0].im * b_x[6].im) -
                   (b[2].re * b_x[4].re - b[2].im * b_x[4].im));
    d = ((b_p_dyn.re * alpha_im + b_p_dyn.im * alpha_re) +
         torque_canards_im * 0.0) -
        ((b[0].re * b_x[6].im + b[0].im * b_x[6].re) -
         (b[2].re * b_x[4].im + b[2].im * b_x[4].re));
    d1 = ((b_p_dyn.re * beta_re - b_p_dyn.im * beta_im) +
          torque_canards_re * 0.0) -
         ((b[1].re * b_x[4].re - b[1].im * b_x[4].im) -
          (b[0].re * b_x[5].re - b[0].im * b_x[5].im));
    d2 = ((b_p_dyn.re * beta_im + b_p_dyn.im * beta_re) +
          torque_canards_im * 0.0) -
         ((b[1].re * b_x[4].im + b[1].im * b_x[4].re) -
          (b[0].re * b_x[5].im + b[0].im * b_x[5].re));
    for (b_i = 0; b_i < 3; b_i++) {
      re = q_tilde[b_i].re;
      im = q_tilde[b_i].im;
      x_re = q_tilde[b_i + 3].re;
      layer_idx_2 = q_tilde[b_i + 3].im;
      p_dyn_re = q_tilde[b_i + 6].re;
      layer_idx_0 = q_tilde[b_i + 6].im;
      w_dot[b_i].re =
          ((re * a_tmp - im * sgnbr) + (x_re * layer_idx_1 - layer_idx_2 * d)) +
          (p_dyn_re * d1 - layer_idx_0 * d2);
      w_dot[b_i].im =
          ((re * sgnbr + im * a_tmp) + (x_re * d + layer_idx_2 * layer_idx_1)) +
          (p_dyn_re * d2 + layer_idx_0 * d1);
    }
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
    cross(&b_x[4], b);
    cross(w_dot, dcv);
    sgnbr = 0.5 * -b_x[4].re;
    dcv1[4].re = sgnbr;
    layer_idx_1 = 0.5 * b_x[4].im;
    dcv1[4].im = layer_idx_1;
    a_tmp = 0.5 * b_x[4].re;
    dcv1[1].re = a_tmp;
    dcv1[1].im = layer_idx_1;
    d = 0.5 * -b_x[5].re;
    dcv1[8].re = d;
    d1 = 0.5 * b_x[5].im;
    dcv1[8].im = d1;
    d2 = 0.5 * b_x[5].re;
    dcv1[2].re = d2;
    dcv1[2].im = d1;
    re = 0.5 * -b_x[6].re;
    dcv1[12].re = re;
    layer_idx_2 = 0.5 * b_x[6].im;
    dcv1[12].im = layer_idx_2;
    p_dyn_re = 0.5 * b_x[6].re;
    dcv1[3].re = p_dyn_re;
    dcv1[3].im = layer_idx_2;
    dcv1[9].re = p_dyn_re;
    dcv1[9].im = layer_idx_2;
    dcv1[13].re = d;
    dcv1[13].im = 0.5 * -b_x[5].im;
    dcv1[6].re = re;
    dcv1[6].im = 0.5 * -b_x[6].im;
    dcv1[14].re = a_tmp;
    dcv1[14].im = layer_idx_1;
    dcv1[7].re = d2;
    dcv1[7].im = d1;
    dcv1[11].re = sgnbr;
    dcv1[11].im = 0.5 * -b_x[4].im;
    b_b[0].re = (b[2].re * b_x[5].re - b[2].im * b_x[5].im) -
                (b[1].re * b_x[6].re - b[1].im * b_x[6].im);
    b_b[0].im = (b[2].re * b_x[5].im + b[2].im * b_x[5].re) -
                (b[1].re * b_x[6].im + b[1].im * b_x[6].re);
    b_b[1].re = (b[0].re * b_x[6].re - b[0].im * b_x[6].im) -
                (b[2].re * b_x[4].re - b[2].im * b_x[4].im);
    b_b[1].im = (b[0].re * b_x[6].im + b[0].im * b_x[6].re) -
                (b[2].re * b_x[4].im + b[2].im * b_x[4].re);
    b_b[2].re = (b[1].re * b_x[4].re - b[1].im * b_x[4].im) -
                (b[0].re * b_x[5].re - b[0].im * b_x[5].im);
    b_b[2].im = (b[1].re * b_x[4].im + b[1].im * b_x[4].re) -
                (b[0].re * b_x[5].im + b[0].im * b_x[5].re);
    p_dyn[0].re = 2.0 * ((b_x[5].re * b_x[9].re - b_x[5].im * b_x[9].im) -
                         (b_x[6].re * b_x[8].re - b_x[6].im * b_x[8].im));
    p_dyn[0].im = 2.0 * ((b_x[5].re * b_x[9].im + b_x[5].im * b_x[9].re) -
                         (b_x[6].re * b_x[8].im + b_x[6].im * b_x[8].re));
    p_dyn[1].re = 2.0 * ((b_x[6].re * b_x[7].re - b_x[6].im * b_x[7].im) -
                         (b_x[4].re * b_x[9].re - b_x[4].im * b_x[9].im));
    p_dyn[1].im = 2.0 * ((b_x[6].re * b_x[7].im + b_x[6].im * b_x[7].re) -
                         (b_x[4].re * b_x[9].im + b_x[4].im * b_x[9].re));
    p_dyn[2].re = 2.0 * ((b_x[4].re * b_x[8].re - b_x[4].im * b_x[8].im) -
                         (b_x[5].re * b_x[7].re - b_x[5].im * b_x[7].im));
    p_dyn[2].im = 2.0 * ((b_x[4].re * b_x[8].im + b_x[4].im * b_x[8].re) -
                         (b_x[5].re * b_x[7].im + b_x[5].im * b_x[7].re));
    sgnbr = b_x[7].re;
    layer_idx_1 = b_x[7].im;
    a_tmp = b_x[8].re;
    d = b_x[8].im;
    d1 = b_x[9].re;
    d2 = b_x[9].im;
    for (b_i = 0; b_i < 3; b_i++) {
      b[b_i].re = dv3[b_i];
      b[b_i].im = 0.0;
      re = S[b_i].re;
      layer_idx_2 = S[b_i].im;
      p_dyn_re = S[b_i + 3].re;
      layer_idx_0 = S[b_i + 3].im;
      im = S[b_i + 6].re;
      x_re = S[b_i + 6].im;
      b_S[b_i].re = ((re * sgnbr - layer_idx_2 * layer_idx_1) +
                     (p_dyn_re * a_tmp - layer_idx_0 * d)) +
                    (im * d1 - x_re * d2);
      b_S[b_i].im = ((re * layer_idx_1 + layer_idx_2 * sgnbr) +
                     (p_dyn_re * d + layer_idx_0 * a_tmp)) +
                    (im * d2 + x_re * d1);
    }
    for (b_i = 0; b_i < 4; b_i++) {
      b_dv1[b_i] =
          (((((dcv1[b_i].re * q[0].im + dcv1[b_i].im * q[0].re) +
              (dcv1[b_i + 4].re * q[1].im + dcv1[b_i + 4].im * q[1].re)) +
             (dcv1[b_i + 8].re * q[2].im + dcv1[b_i + 8].im * q[2].re)) +
            (dcv1[b_i + 12].re * q[3].im + dcv1[b_i + 12].im * q[3].re)) +
           a * (q[b_i].im - b_x[b_i].im)) /
          h;
    }
    sgnbr = b[0].im;
    layer_idx_1 = b[0].re;
    a_tmp = b[1].im;
    d = b[1].re;
    d1 = b[2].im;
    d2 = b[2].re;
    for (b_i = 0; b_i < 3; b_i++) {
      i = 3 * b_i + 1;
      S_re_tmp = 3 * b_i + 2;
      dv2[b_i] = ((((0.0 - dcv[b_i].im) - b_b[b_i].im) - p_dyn[b_i].im) +
                  (((S[3 * b_i].re * sgnbr + -S[3 * b_i].im * layer_idx_1) +
                    (S[i].re * a_tmp + -S[i].im * d)) +
                   (S[S_re_tmp].re * d1 + -S[S_re_tmp].im * d2))) /
                 h;
    }
    Jx[13 * k] = b_dv1[0];
    Jx[13 * k + 1] = b_dv1[1];
    Jx[13 * k + 2] = b_dv1[2];
    Jx[13 * k + 3] = b_dv1[3];
    Jx[13 * k + 4] = w_dot[0].im / h;
    Jx[13 * k + 7] = dv2[0];
    Jx[13 * k + 5] = w_dot[1].im / h;
    Jx[13 * k + 8] = dv2[1];
    Jx[13 * k + 6] = w_dot[2].im / h;
    Jx[13 * k + 9] = dv2[2];
    Jx[13 * k + 10] = b_S[0].im / h;
    Jx[13 * k + 11] = -100.0 * b_x[11].im / h;
    Jx[13 * k + 12] = -60.0 * b_x[12].im / h;
  }
}

/* End of code generation (jacobian.c) */
