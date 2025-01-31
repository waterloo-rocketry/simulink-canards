#include "SensorDataManager.h"

SensorDataManager::SensorDataManager()
    : imu_data_available_(false)
    , slam_data_available_(false)
    , wheelspeed_data_available_(false)
    , gps_data_available_(false)
    , control_output_data_available_(false) {}

SensorDataManager::~SensorDataManager() {}

void SensorDataManager::addImuData(const sensor_msgs::Imu::ConstPtr& data) {
    imu_data_ << data->linear_acceleration.x, data->linear_acceleration.y, data->angular_velocity.z;
    imu_data_available_ = true;
}

void SensorDataManager::addSlamData(const nav_msgs::Odometry::ConstPtr& data) {
    slam_data_ << data->pose.pose.position.x, data->pose.pose.position.y, double(OdometryHandler::get2dYaw(data->pose.pose.orientation));
    slam_data_available_ = true;
}

void SensorDataManager::addWheelSpeedData(const egn_messages::CarSensors::ConstPtr& data) {
    wheelspeed_data_ << carParameter_.wheelSpeedToVelocity(data->wheelSpeedFL),
                        carParameter_.wheelSpeedToVelocity(data->wheelSpeedFR),
                        carParameter_.wheelSpeedToVelocity(data->wheelSpeedRL),
                        carParameter_.wheelSpeedToVelocity(data->wheelSpeedRR);
    wheelspeed_data_available_ = true;
}

void SensorDataManager::addGpsData(const sensor_msgs::NavSatFix::ConstPtr& data) {
    gps_data_ << data->latitude, data->longitude;
    gps_data_available_ = true;
}

void SensorDataManager::addControlOutputData(const egn_messages::DVControlOutput::ConstPtr& data) {
    double torque = data->torqueSetpoint;
    torque = std::max(-10.0, torque);
    control_output_data_ << data->steerAngleSetpoint, torque;
    control_output_data_available_ = true;
}

const Eigen::Matrix<double, 3, 1> SensorDataManager::getImuData()
{
    imu_data_available_ = false;
    return imu_data_;
}

const Eigen::Matrix<double, 3, 1> SensorDataManager::getSlamData() { 
    slam_data_available_ = false;
    return slam_data_; 
}

const Eigen::Matrix<double, 4, 1> SensorDataManager::getWheelSpeedData() {
    wheelspeed_data_available_ = false;
    return wheelspeed_data_; 
}

const Eigen::Matrix<double, 2, 1> SensorDataManager::getGpsData() { 
    gps_data_available_ = false;
    return gps_data_; 
}

const Eigen::Matrix<double, 2, 1> SensorDataManager::getControlOutputData() { 
    control_output_data_available_ = false;
    return control_output_data_; 
}

bool SensorDataManager::isImuDataAvailable() { return imu_data_available_; }
bool SensorDataManager::isSlamDataAvailable() { return slam_data_available_; }
bool SensorDataManager::isWheelSpeedDataAvailable() { return wheelspeed_data_available_; }
bool SensorDataManager::isGpsDataAvailable() { return gps_data_available_; }
bool SensorDataManager::isControlOutputDataAvailable() { return control_output_data_available_; }
