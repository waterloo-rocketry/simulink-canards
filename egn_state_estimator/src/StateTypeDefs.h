#pragma once

#include <Eigen/Dense>

// Define a macro for the state size
constexpr int StateSize = 13;       // x, y, vx, vy, acc x, acc y, yaw, yawrate, slipL, slipR, ca, gpsHeadingOffset, steeringAngle
                                    // also change the enum in State.h!
constexpr int MeasurementSize = 8;  // imu ax, imu ay, imu yawrate, slam x, slam y, slam yaw, whelSpeedL, whelSpeedR

// Define type aliases for vectors and matrices of fixed size
using VectorState = Eigen::Matrix<double, StateSize, 1>;
using MatrixState = Eigen::Matrix<double, StateSize, StateSize>;
using VectorMeasurement = Eigen::Matrix<double, MeasurementSize, 1>;
using MatrixMeasurement = Eigen::Matrix<double, MeasurementSize, MeasurementSize>;
using MatrixStateMeasurement = Eigen::Matrix<double, StateSize, MeasurementSize>;
using MatrixMeasurementState = Eigen::Matrix<double, MeasurementSize, StateSize>;