#pragma once

#include "StateTypeDefs.h"
#include "filter/State.h"
#include "egn_messages/include/CarParameter.h"

#include <ros/ros.h>

class PredictionModel
{
  public:

    MatrixState getQ() const { return Q_; }

    // set control inputs
    void setControlInputs(Eigen::VectorXd controlOutputData)
    {
        steeringAngle_ = controlOutputData(0);
        torqueSetpoint_ = controlOutputData(1);
    }

    // Predict function with state and dt
    virtual VectorState predict(const VectorState& state, double dt) const = 0;


    // Virtual Jacobian function
    virtual MatrixState getJacobian(const VectorState& state, double dt) const { return numericalJacobian(state, dt); }

  protected:
    // Numerical Jacobian calculation
    MatrixState numericalJacobian(const VectorState& state, double dt) const
    {
        constexpr double epsilon = 1e-5;
        MatrixState jacobian;
        VectorState f0 = predict(state, dt);

        for (int i = 0; i < StateSize; ++i) {
            VectorState perturbedState = state;
            perturbedState(i) += epsilon;
            VectorState fi = predict(perturbedState, dt);
            jacobian.col(i) = (fi - f0) / epsilon;
        }

        return jacobian;
    }

    MatrixState Q_;
    double steeringAngle_;
    double torqueSetpoint_;

    CarParameter carParameter_;
};
