#pragma once

#include "PredictionModel.h"

class ConstantAccelerationModel : public PredictionModel
{
  public:
    ConstantAccelerationModel() {
        Q_ = MatrixState::Zero();
        Q_(State::x, State::x) = 1.0;
        Q_(State::y, State::y) = 1.0;
        Q_(State::yaw, State::yaw) = 1.0;
        Q_(State::vX, State::vX) = 50.0;
        Q_(State::vY, State::vY) = 50.0;
        Q_(State::yawRate, State::yawRate) = 100.0;
        Q_(State::accX, State::accX) = 1000.0;
        Q_(State::accY, State::accY) = 1000.0;
        Q_(State::steeringAngle, State::steeringAngle) = 100.0;
        Q_(State::slipL, State::slipL) = 1000.0;
        Q_(State::slipR, State::slipR) = 1000.0;
    }

    ~ConstantAccelerationModel() = default;

    MatrixState getQ() const { return Q_; }

    VectorState predict(const VectorState& state, double dt) const override
    {
        VectorState newState = state;
        double x = state(State::x);
        double y = state(State::y);
        double yaw = state(State::yaw);
        double vx = state(State::vX);
        double vy = state(State::vY);
        double yawrate = state(State::yawRate);
        double ax = state(State::accX);
        double ay = state(State::accY);

        newState(State::x) += vx * dt * cos(yaw) - vy * dt * sin(yaw);
        newState(State::y) += vx * dt * sin(yaw) + vy * dt * cos(yaw);
        newState(State::yaw) += yawrate * dt;
        newState(State::vX) += (ax - (vy * yawrate)) * dt;
        newState(State::vY) += (ay + (vx * yawrate)) * dt;

        return newState;
    }

    MatrixState getJacobian(const VectorState& state, double dt) const override { return numericalJacobian(state, dt); }
};