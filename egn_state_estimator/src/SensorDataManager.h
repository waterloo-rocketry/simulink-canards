#pragma once

#include <memory>
#include <queue>
#include <Eigen/Dense>

#include "egn_messages/CarSensors.h"
#include "egn_messages/DVControlOutput.h"
#include <nav_msgs/Odometry.h>
#include <sensor_msgs/Imu.h>
#include <sensor_msgs/NavSatFix.h>

#include "egn_datatype_handlers/src/quaternion_handler.hpp"
#include "egn_messages/include/CarParameter.h"

class SensorDataManager
{
  public:
    SensorDataManager();
    ~SensorDataManager();

    void addImuData(const sensor_msgs::Imu::ConstPtr& data);
    void addSlamData(const nav_msgs::Odometry::ConstPtr& data);
    void addWheelSpeedData(const egn_messages::CarSensors::ConstPtr& data);
    void addGpsData(const sensor_msgs::NavSatFix::ConstPtr& data);
    void addControlOutputData(const egn_messages::DVControlOutput::ConstPtr& data);

    const Eigen::Matrix<double, 3, 1> getImuData();
    const Eigen::Matrix<double, 3, 1> getSlamData();
    const Eigen::Matrix<double, 4, 1> getWheelSpeedData();
    const Eigen::Matrix<double, 2, 1> getGpsData();
    const Eigen::Matrix<double, 2, 1> getControlOutputData();

    bool isImuDataAvailable();
    bool isSlamDataAvailable();
    bool isWheelSpeedDataAvailable();
    bool isGpsDataAvailable();
    bool isControlOutputDataAvailable();

  private:
    Eigen::Matrix<double, 3, 1> imu_data_;            // accelx, accely, yawrate
    Eigen::Matrix<double, 3, 1> slam_data_;           // x, y, yaw
    Eigen::Matrix<double, 4, 1> wheelspeed_data_;     // FL, FR, RL, RR
    Eigen::Matrix<double, 2, 1> gps_data_;            // lat, lon
    Eigen::Matrix<double, 2, 1> control_output_data_; // steering angle, torque

    bool imu_data_available_;
    bool slam_data_available_;
    bool wheelspeed_data_available_;
    bool gps_data_available_;
    bool control_output_data_available_;

    CarParameter carParameter_;
};