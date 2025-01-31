#pragma once

#include "PredictionModel.h"

class SimpleDynamicSlip : public PredictionModel
{
  public:
    SimpleDynamicSlip()
    : nh_("~")
    {
        nh_.param("kalman/predict_x", q_x, 0.1);
        nh_.param("kalman/predict_y", q_y, 0.1);
        nh_.param("kalman/predict_vx", q_vx, 0.1);
        nh_.param("kalman/predict_vy", q_vy, 0.1);
        nh_.param("kalman/predict_ax", q_ax, 0.1);
        nh_.param("kalman/predict_ay", q_ay, 0.1);
        nh_.param("kalman/predict_yaw", q_yaw, 0.1);
        nh_.param("kalman/predict_yawrate", q_yawrate, 0.1);
        nh_.param("kalman/predict_steer", q_steer, 0.1);
        nh_.param("kalman/predict_slip", q_slip, 0.1);
        nh_.param("kalman/predict_ca", q_ca, 0.1);
        nh_.param("kalman/predict_gps", q_gps, 0.1);

        nh_.param("kalman/tire_b", tire_b, 6.5);
        nh_.param("kalman/tire_c", tire_c, 2.0);
        nh_.param("kalman/tire_d", tire_d, 1.5);
        nh_.param("kalman/tire_e", tire_e, 0.9);
        corneringStiffness = tire_b * tire_c * tire_d;

        Q_ = MatrixState::Zero();
        Q_(State::x, State::x) = q_x;
        Q_(State::y, State::y) = q_y;
        Q_(State::yaw, State::yaw) = q_yaw;
        Q_(State::vX, State::vX) = q_vx;
        Q_(State::vY, State::vY) = q_vy;
        Q_(State::yawRate, State::yawRate) = q_yawrate;
        Q_(State::accX, State::accX) = q_ax;
        Q_(State::accY, State::accY) = q_ay;
        Q_(State::steeringAngle, State::steeringAngle) = q_steer;
        Q_(State::slipL, State::slipL) = q_slip;
        Q_(State::slipR, State::slipR) = q_slip;
        Q_(State::ca, State::ca) = q_ca;
        Q_(State::gpsHeadingOffset, State::gpsHeadingOffset) = q_gps;
    }

    ~SimpleDynamicSlip() = default;

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
        double slipL = state(State::slipL);
        double slipR = state(State::slipR);
        double ca = state(State::ca);
        double gps = state(State::gpsHeadingOffset);

        newState(State::x) += vx * dt * cos(yaw) - vy * dt * sin(yaw);
        newState(State::y) += vx * dt * sin(yaw) + vy * dt * cos(yaw);
        newState(State::yaw) += yawrate * dt;
        newState(State::vX) += (ax - (vy * yawrate)) * dt;
        newState(State::vY) += (ay + (vx * yawrate)) * dt;
        newState(State::accX) = magicFormula((slipL + slipR) / 2.0) * 9.81 * 0.5 * carParameter_.car.weightPercentageRear;
        newState(State::slipL) = (torqueSetpoint_ - 5.0) * carParameter_.car.transmissionRatio / carParameter_.tire.radius /
                                  (corneringStiffness * 9.81 * carParameter_.car.mass * 0.5 * carParameter_.car.weightPercentageRear);
        newState(State::slipR) = (torqueSetpoint_ - 5.0) * carParameter_.car.transmissionRatio / carParameter_.tire.radius /
                                  (corneringStiffness * 9.81 * carParameter_.car.mass * 0.5 * carParameter_.car.weightPercentageRear);

        return newState;
    }

    MatrixState getJacobian(const VectorState& state, double dt) const override { return numericalJacobian(state, dt); }

  private:
    ros::NodeHandle nh_;

    double q_x;
    double q_y;
    double q_vx;
    double q_vy;
    double q_ax;
    double q_ay;
    double q_yaw;
    double q_yawrate;
    double q_steer;
    double q_slip;
    double q_ca;
    double q_gps;

    double tire_b;
    double tire_c;
    double tire_d;
    double tire_e;
    double corneringStiffness;

    double magicFormula(double slip) const
    {
        return tire_d * sin(tire_c * atan(tire_b * slip - tire_e * (tire_b * slip - atan(tire_b * slip))));
    }
};