#pragma once

#include <nav_msgs/Odometry.h>
#include <ros/ros.h>
#include <sensor_msgs/Imu.h>
#include <sensor_msgs/NavSatFix.h>
#include <tf/transform_broadcaster.h>

#include "egn_messages/DVControlOutput.h"
#include "egn_messages/CarSensors.h"

#include "filter/KalmanFilter.h"
#include "filter/State.h"
#include "measurement/ImuMeasurementModel.h"
#include "measurement/SlamMeasurementModel.h"
#include "measurement/WheelSpeedMeasurementModel.h"
// #include "measurement/GpsMeasurementModel.h"
#include "prediction/ConstantAccelerationModel.h"
#include "prediction/SimpleDynamicSlip.h"
#include "SensorDataManager.h"

#include "egn_messages/include/CarParameter.h"
#include "egn_datatype_handlers/src/quaternion_handler.hpp"
#include "egn_shared_algorithms/inc/runtimeLogger.h"

class StateEstimatorNode
{
  public:
    StateEstimatorNode(const double updateRate);
    ~StateEstimatorNode();

    void run();

  private:
    bool debug_;

    double updateRate_;

    bool enableGpsCorrection_;
    bool enableImuCorrection_;
    bool enableLIDARCorrection_;
    bool enableWheelSpeedCorrection_;
    bool enableDynamicModel_;

    void imuCallback(const sensor_msgs::Imu::ConstPtr& msg);
    void slamCallback(const nav_msgs::Odometry::ConstPtr& msg);
    void carSensorCallback(const egn_messages::CarSensors::ConstPtr& msg);
    void gpsCallback(const sensor_msgs::NavSatFix::ConstPtr& msg);
    void controlOutputCallback(const egn_messages::DVControlOutput::ConstPtr& msg);

    void executeFilter();
    void publishStateEstimate();
    void publishWorldFrameTransform(const nav_msgs::Odometry& odom);

    ros::NodeHandle nodehandle_;
    ros::NodeHandle nh_; // private nodehandle

    ros::Subscriber imuSub_;
    ros::Subscriber slamSub_;
    ros::Subscriber carSensorSub_;
    ros::Subscriber gpsSub_;
    ros::Subscriber controlOutputSub_;

    ros::Publisher cogPosPublisher_;
    ros::Publisher frontAxelPublisher_;
    ros::Publisher rearAxelPublisher_;
    ros::Publisher stateEstimatePublisher_;

    RunTimeLogger kalmanTimeLogger_;

    std::shared_ptr<SensorDataManager> data_manager_;
    std::shared_ptr<State> state_;
    std::shared_ptr<KalmanFilter> kalman_filter_;

    CarParameter carParameter_;
};
