/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * main.c
 *
 * Code generation for function 'main'
 *
 */

/*************************************************************************/
/* This automatically generated example C main file shows how to call    */
/* entry-point functions that MATLAB Coder generated. You must customize */
/* this file for your application. Do not modify this file directly.     */
/* Instead, make a copy of this file, modify it, and integrate it into   */
/* your development environment.                                         */
/*                                                                       */
/* This file initializes entry-point function arguments to a default     */
/* size and value before calling the entry-point functions. It does      */
/* not store or use any values returned from the entry-point functions.  */
/* If necessary, it does pre-allocate memory for returned values.        */
/* You can use this file as a starting point for a main function that    */
/* you can deploy in your application.                                   */
/*                                                                       */
/* After you copy the file, and before you deploy it, you must make the  */
/* following changes:                                                    */
/* * For variable-size function arguments, change the example sizes to   */
/* the sizes that your application requires.                             */
/* * Change the example values of function arguments to the values that  */
/* your application requires.                                            */
/* * If the entry-point functions return values, store these values or   */
/* otherwise use them as required by your application.                   */
/*                                                                       */
/*************************************************************************/

/* Include files */
#include "main.h"
#include "ekf_algorithm.h"
#include "ekf_algorithm_terminate.h"
#include "rt_nonfinite.h"

/* Function Declarations */
static void argInit_13x13_real_T(double result[169]);

static void argInit_13x1_real_T(double result[13]);

static void argInit_4x1_real_T(double result[4]);

static void argInit_8x1_real_T(double result[8]);

static void argInit_8x8_real_T(double result[64]);

static double argInit_real_T(void);

/* Function Definitions */
static void argInit_13x13_real_T(double result[169])
{
  int i;
  /* Loop over the array to initialize each element. */
  for (i = 0; i < 169; i++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[i] = argInit_real_T();
  }
}

static void argInit_13x1_real_T(double result[13])
{
  int idx0;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 13; idx0++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[idx0] = argInit_real_T();
  }
}

static void argInit_4x1_real_T(double result[4])
{
  int idx0;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 4; idx0++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[idx0] = argInit_real_T();
  }
}

static void argInit_8x1_real_T(double result[8])
{
  int idx0;
  /* Loop over the array to initialize each element. */
  for (idx0 = 0; idx0 < 8; idx0++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[idx0] = argInit_real_T();
  }
}

static void argInit_8x8_real_T(double result[64])
{
  int i;
  /* Loop over the array to initialize each element. */
  for (i = 0; i < 64; i++) {
    /* Set the value of the array element.
Change this value to the value that the application requires. */
    result[i] = argInit_real_T();
  }
}

static double argInit_real_T(void)
{
  return 0.0;
}

int main(int argc, char **argv)
{
  (void)argc;
  (void)argv;
  /* The initialize function is being called automatically from your entry-point
   * function. So, a call to initialize is not included here. */
  /* Invoke the entry-point functions.
You can call entry-point functions multiple times. */
  main_ekf_algorithm();
  /* Terminate the application.
You do not need to do this more than one time. */
  ekf_algorithm_terminate();
  return 0;
}

void main_ekf_algorithm(void)
{
  double P_new[169];
  double P_tmp[169];
  double dv3[64];
  double b_dv[13];
  double x_new[13];
  double dv2[8];
  double b_dv1[4];
  double t_tmp;
  /* Initialize function 'ekf_algorithm' input arguments. */
  /* Initialize function input argument 'x'. */
  /* Initialize function input argument 'P'. */
  argInit_13x13_real_T(P_tmp);
  /* Initialize function input argument 'u'. */
  /* Initialize function input argument 'y'. */
  t_tmp = argInit_real_T();
  /* Initialize function input argument 'Q'. */
  /* Initialize function input argument 'R'. */
  /* Call the entry-point 'ekf_algorithm'. */
  argInit_13x1_real_T(b_dv);
  argInit_4x1_real_T(b_dv1);
  argInit_8x1_real_T(dv2);
  argInit_8x8_real_T(dv3);
  ekf_algorithm(b_dv, P_tmp, b_dv1, dv2, t_tmp, P_tmp, dv3, t_tmp, t_tmp, x_new,
                P_new);
}

/* End of code generation (main.c) */
