#pragma once

#include "StateTypeDefs.h"
#include "egn_datatype_handlers/src/quaternion_handler.hpp"
#include "egn_messages/StateEstimate.h"
#include <Eigen/Dense>
#include <nav_msgs/Odometry.h>

class State{

public:
  State();
  State(VectorState stateVector);
  ~State(){};

  enum state { x = 0, y = 1, vX = 2, vY = 3, accX = 4, accY = 5, yaw = 6, yawRate = 7, slipL = 8, slipR = 9, ca = 10, gpsHeadingOffset = 11, steeringAngle = 12 };

  void setStateVector(VectorState stateVec);
  const VectorState& getStateVector() const;
  void setState(int stateId, double value);
  double getState(int stateId) const;

  nav_msgs::Odometry state2Odometry(double shiftDistance);
  egn_messages::StateEstimate state2StateEstimate();

private:
  VectorState stateVector_;
};