#include "State.h"

State::State() {
    stateVector_ = VectorState::Zero();
    stateVector_(state::ca) = 10.0;
    stateVector_(state::gpsHeadingOffset) = 6.5;
}

State::State(VectorState stateVector) {
    stateVector_ = stateVector;
}

void State::setStateVector(VectorState stateVec) { stateVector_ = stateVec; }

const VectorState& State::getStateVector() const { return stateVector_; }

void State::setState(int stateId, double value)
{
    stateVector_(stateId) = value;
}

double State::getState(int stateId) const
{
    return stateVector_(stateId);
}

nav_msgs::Odometry State::state2Odometry(double shiftDistance)
{
    double vyTrans = stateVector_(state::vY) + shiftDistance * stateVector_(state::yawRate);
    double xTrans = stateVector_(state::x) + shiftDistance * std::cos(stateVector_(state::yaw));
    double yTrans = stateVector_(state::y) + shiftDistance * std::sin(stateVector_(state::yaw));

    nav_msgs::Odometry odom;


    // Position (trackframe) is written in message
    odom.pose.pose.position.x = xTrans;
    odom.pose.pose.position.y = yTrans;
    odom.pose.pose.position.z = 0;

    // Orientation of the Car (Car frame) is written into messageType
    odom.pose.pose.orientation = OdometryHandler::get2dQuaternionMsg(stateVector_(state::yaw));

    // Velocity in x,y is written into message
    odom.twist.twist.linear.x = stateVector_(state::vX);
    odom.twist.twist.linear.y = vyTrans;
    odom.twist.twist.linear.z = 0;

    // angular velocity is written into message (x: pitchrate, y: rollrate, z: yawrate)
    odom.twist.twist.angular.x = 0.0;
    odom.twist.twist.angular.y = 0.0;
    odom.twist.twist.angular.z = stateVector_(state::yawRate);

    // time and position is written into message
    odom.child_frame_id = "car_base";
    odom.header.stamp = ros::Time::now();
    // std::cout << "Odometry time: " << odom.header.stamp.toNSec() << std::endl;
    odom.header.frame_id = "world";

    return odom;
}

egn_messages::StateEstimate State::state2StateEstimate()
{
    egn_messages::StateEstimate stateEstimate;
    stateEstimate.header.stamp = ros::Time::now();
    stateEstimate.header.frame_id = "world";
    stateEstimate.x = stateVector_(state::x);
    stateEstimate.y = stateVector_(state::y);
    stateEstimate.vx = stateVector_(state::vX);
    stateEstimate.vy = stateVector_(state::vY);
    stateEstimate.accx = stateVector_(state::accX);
    stateEstimate.accy = stateVector_(state::accY);
    stateEstimate.yaw = stateVector_(state::yaw);
    stateEstimate.yaw_rate = stateVector_(state::yawRate);
    stateEstimate.slip_fl = stateVector_(state::slipL);
    stateEstimate.slip_fr = stateVector_(state::slipR);
    stateEstimate.ca = stateVector_(state::ca);
    stateEstimate.gps_heading_offset = stateVector_(state::gpsHeadingOffset);
    stateEstimate.steering_angle = stateVector_(state::steeringAngle);
    return stateEstimate;
}