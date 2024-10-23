/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 *
 * File: test_codegen.h
 *
 * Code generated for Simulink model 'test_codegen'.
 *
 * Model version                  : 1.2
 * Simulink Coder version         : 24.2 (R2024b) 21-Jun-2024
 * C/C++ source code generated on : Wed Oct 23 20:06:05 2024
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex-M
 * Code generation objectives:
 *    1. Execution efficiency
 *    2. RAM efficiency
 * Validation result: Not run
 */

#ifndef test_codegen_h_
#define test_codegen_h_
#ifndef test_codegen_COMMON_INCLUDES_
#define test_codegen_COMMON_INCLUDES_
#include "rtwtypes.h"
#include "rtw_continuous.h"
#include "rtw_solver.h"
#endif                                 /* test_codegen_COMMON_INCLUDES_ */

#include <string.h>

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
#define rtmGetErrorStatus(rtm)         ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
#define rtmSetErrorStatus(rtm, val)    ((rtm)->errorStatus = (val))
#endif

#ifndef rtmGetStopRequested
#define rtmGetStopRequested(rtm)       ((rtm)->Timing.stopRequestedFlag)
#endif

#ifndef rtmSetStopRequested
#define rtmSetStopRequested(rtm, val)  ((rtm)->Timing.stopRequestedFlag = (val))
#endif

#ifndef rtmGetStopRequestedPtr
#define rtmGetStopRequestedPtr(rtm)    (&((rtm)->Timing.stopRequestedFlag))
#endif

#ifndef rtmGetT
#define rtmGetT(rtm)                   (rtmGetTPtr((rtm))[0])
#endif

#ifndef rtmGetTPtr
#define rtmGetTPtr(rtm)                ((rtm)->Timing.t)
#endif

#ifndef rtmGetTStart
#define rtmGetTStart(rtm)              ((rtm)->Timing.tStart)
#endif

/* Forward declaration for rtModel */
typedef struct tag_RTM RT_MODEL;

/* Block signals and states (default storage) for system '<Root>' */
typedef struct {
  real_T FilterCoefficient;            /* '<S39>/Filter Coefficient' */
} DW;

/* Continuous states (default storage) */
typedef struct {
  real_T Integrator_CSTATE;            /* '<S36>/Integrator' */
  real_T Filter_CSTATE;                /* '<S31>/Filter' */
} X;

/* State derivatives (default storage) */
typedef struct {
  real_T Integrator_CSTATE;            /* '<S36>/Integrator' */
  real_T Filter_CSTATE;                /* '<S31>/Filter' */
} XDot;

/* State disabled  */
typedef struct {
  boolean_T Integrator_CSTATE;         /* '<S36>/Integrator' */
  boolean_T Filter_CSTATE;             /* '<S31>/Filter' */
} XDis;

#ifndef ODE3_INTG
#define ODE3_INTG

/* ODE3 Integration Data */
typedef struct {
  real_T *y;                           /* output */
  real_T *f[3];                        /* derivatives */
} ODE3_IntgData;

#endif

/* Real-time Model Data Structure */
struct tag_RTM {
  const char_T *errorStatus;
  RTWSolverInfo solverInfo;
  X *contStates;
  int_T *periodicContStateIndices;
  real_T *periodicContStateRanges;
  real_T *derivs;
  XDis *contStateDisabled;
  boolean_T zCCacheNeedsReset;
  boolean_T derivCacheNeedsReset;
  boolean_T CTOutputIncnstWithState;
  real_T odeY[2];
  real_T odeF[3][2];
  ODE3_IntgData intgData;
  DW *dwork;

  /*
   * Sizes:
   * The following substructure contains sizes information
   * for many of the model attributes such as inputs, outputs,
   * dwork, sample times, etc.
   */
  struct {
    int_T numContStates;
    int_T numPeriodicContStates;
    int_T numSampTimes;
  } Sizes;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    uint32_T clockTick0;
    time_T stepSize0;
    time_T tStart;
    SimTimeStep simTimeStep;
    boolean_T stopRequestedFlag;
    time_T *t;
    time_T tArray[1];
  } Timing;
};

/* Model entry point functions */
extern void test_codegen_initialize(RT_MODEL *const rtM);
extern void test_codegen_step(RT_MODEL *const rtM, real_T rtU_thisIsAnInput,
  real_T *rtY_thisIsAnOutput);

/*-
 * These blocks were eliminated from the model due to optimizations:
 *
 * Block '<S33>/Integral Gain' : Eliminated nontunable gain of 1
 * Block '<S41>/Proportional Gain' : Eliminated nontunable gain of 1
 */

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Use the MATLAB hilite_system command to trace the generated code back
 * to the model.  For example,
 *
 * hilite_system('<S3>')    - opens system 3
 * hilite_system('<S3>/Kp') - opens and selects block Kp which resides in S3
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'test_codegen'
 * '<S1>'   : 'test_codegen/PID Controller'
 * '<S2>'   : 'test_codegen/PID Controller/Anti-windup'
 * '<S3>'   : 'test_codegen/PID Controller/D Gain'
 * '<S4>'   : 'test_codegen/PID Controller/External Derivative'
 * '<S5>'   : 'test_codegen/PID Controller/Filter'
 * '<S6>'   : 'test_codegen/PID Controller/Filter ICs'
 * '<S7>'   : 'test_codegen/PID Controller/I Gain'
 * '<S8>'   : 'test_codegen/PID Controller/Ideal P Gain'
 * '<S9>'   : 'test_codegen/PID Controller/Ideal P Gain Fdbk'
 * '<S10>'  : 'test_codegen/PID Controller/Integrator'
 * '<S11>'  : 'test_codegen/PID Controller/Integrator ICs'
 * '<S12>'  : 'test_codegen/PID Controller/N Copy'
 * '<S13>'  : 'test_codegen/PID Controller/N Gain'
 * '<S14>'  : 'test_codegen/PID Controller/P Copy'
 * '<S15>'  : 'test_codegen/PID Controller/Parallel P Gain'
 * '<S16>'  : 'test_codegen/PID Controller/Reset Signal'
 * '<S17>'  : 'test_codegen/PID Controller/Saturation'
 * '<S18>'  : 'test_codegen/PID Controller/Saturation Fdbk'
 * '<S19>'  : 'test_codegen/PID Controller/Sum'
 * '<S20>'  : 'test_codegen/PID Controller/Sum Fdbk'
 * '<S21>'  : 'test_codegen/PID Controller/Tracking Mode'
 * '<S22>'  : 'test_codegen/PID Controller/Tracking Mode Sum'
 * '<S23>'  : 'test_codegen/PID Controller/Tsamp - Integral'
 * '<S24>'  : 'test_codegen/PID Controller/Tsamp - Ngain'
 * '<S25>'  : 'test_codegen/PID Controller/postSat Signal'
 * '<S26>'  : 'test_codegen/PID Controller/preInt Signal'
 * '<S27>'  : 'test_codegen/PID Controller/preSat Signal'
 * '<S28>'  : 'test_codegen/PID Controller/Anti-windup/Passthrough'
 * '<S29>'  : 'test_codegen/PID Controller/D Gain/Internal Parameters'
 * '<S30>'  : 'test_codegen/PID Controller/External Derivative/Error'
 * '<S31>'  : 'test_codegen/PID Controller/Filter/Cont. Filter'
 * '<S32>'  : 'test_codegen/PID Controller/Filter ICs/Internal IC - Filter'
 * '<S33>'  : 'test_codegen/PID Controller/I Gain/Internal Parameters'
 * '<S34>'  : 'test_codegen/PID Controller/Ideal P Gain/Passthrough'
 * '<S35>'  : 'test_codegen/PID Controller/Ideal P Gain Fdbk/Disabled'
 * '<S36>'  : 'test_codegen/PID Controller/Integrator/Continuous'
 * '<S37>'  : 'test_codegen/PID Controller/Integrator ICs/Internal IC'
 * '<S38>'  : 'test_codegen/PID Controller/N Copy/Disabled'
 * '<S39>'  : 'test_codegen/PID Controller/N Gain/Internal Parameters'
 * '<S40>'  : 'test_codegen/PID Controller/P Copy/Disabled'
 * '<S41>'  : 'test_codegen/PID Controller/Parallel P Gain/Internal Parameters'
 * '<S42>'  : 'test_codegen/PID Controller/Reset Signal/Disabled'
 * '<S43>'  : 'test_codegen/PID Controller/Saturation/Passthrough'
 * '<S44>'  : 'test_codegen/PID Controller/Saturation Fdbk/Disabled'
 * '<S45>'  : 'test_codegen/PID Controller/Sum/Sum_PID'
 * '<S46>'  : 'test_codegen/PID Controller/Sum Fdbk/Disabled'
 * '<S47>'  : 'test_codegen/PID Controller/Tracking Mode/Disabled'
 * '<S48>'  : 'test_codegen/PID Controller/Tracking Mode Sum/Passthrough'
 * '<S49>'  : 'test_codegen/PID Controller/Tsamp - Integral/TsSignalSpecification'
 * '<S50>'  : 'test_codegen/PID Controller/Tsamp - Ngain/Passthrough'
 * '<S51>'  : 'test_codegen/PID Controller/postSat Signal/Forward_Path'
 * '<S52>'  : 'test_codegen/PID Controller/preInt Signal/Internal PreInt'
 * '<S53>'  : 'test_codegen/PID Controller/preSat Signal/Forward_Path'
 */
#endif                                 /* test_codegen_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
