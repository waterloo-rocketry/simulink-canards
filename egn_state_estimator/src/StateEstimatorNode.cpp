#include "StateEstimatorNode.h"

StateEstimatorNode::StateEstimatorNode(const double updateRate)
    : nh_("~")
    , updateRate_(updateRate)
    , enableGpsCorrection_(false)
    , enableImuCorrection_(false)
    , enableLIDARCorrection_(false)
    , enableWheelSpeedCorrection_(false)
    , enableDynamicModel_(false)
    , cogPosPublisher_(nodehandle_.advertise<nav_msgs::Odometry>("/cog_position", 1))
    , frontAxelPublisher_(nodehandle_.advertise<nav_msgs::Odometry>("/front_position", 1))
    , rearAxelPublisher_(nodehandle_.advertise<nav_msgs::Odometry>("/odometry", 1))
    , stateEstimatePublisher_(nodehandle_.advertise<egn_messages::StateEstimate>("/state_estimate", 1))
    , kalmanTimeLogger_("kalman_time.csv")

{
    // get parameters
    nh_.param("debugMode", debug_, false);
    nh_.param("enableGPSCorrection", enableGpsCorrection_, false);
    nh_.param("enableImuCorrection", enableImuCorrection_, false);
    nh_.param("enableLIDARCorrection", enableLIDARCorrection_, false);
    nh_.param("enableWheelSpeedCorrection", enableWheelSpeedCorrection_, false);
    nh_.param("enableDynamicModel", enableDynamicModel_, false);

    // initialize components
    data_manager_ = std::make_shared<SensorDataManager>();
    state_ = std::make_shared<State>();
    kalman_filter_ = std::make_shared<KalmanFilter>();

    if (enableImuCorrection_) {
        imuSub_ = nodehandle_.subscribe("/imu", 1, &StateEstimatorNode::imuCallback, this);
        kalman_filter_->addMeasurementModel(std::make_shared<ImuMeasurementModel>(debug_, nh_, nodehandle_));
    }
    if (enableLIDARCorrection_) {
        slamSub_ = nodehandle_.subscribe("/odometry/slam", 1, &StateEstimatorNode::slamCallback, this);
        kalman_filter_->addMeasurementModel(std::make_shared<SlamMeasurementModel>(debug_, nh_, nodehandle_));
    }
    if (enableWheelSpeedCorrection_) {
        carSensorSub_ = nodehandle_.subscribe("/car_sensors", 1, &StateEstimatorNode::carSensorCallback, this);
        kalman_filter_->addMeasurementModel(std::make_shared<WheelSpeedMeasurementModel>(debug_, nh_, nodehandle_));
    }
    if (enableGpsCorrection_) {
        gpsSub_ = nodehandle_.subscribe("/mti/fix", 1, &StateEstimatorNode::gpsCallback, this);
        // kalman_filter_->addMeasurementModel(std::make_shared<GpsMeasurementModel>(debug_, nh_, nodehandle_));
    }
    if (enableDynamicModel_) {
        controlOutputSub_ = nodehandle_.subscribe("/dv_control_output", 1, &StateEstimatorNode::controlOutputCallback, this);
    } else {
        controlOutputSub_ = nodehandle_.subscribe("/dv_control_output", 1, &StateEstimatorNode::controlOutputCallback, this);
        kalman_filter_->setPredictionModel(std::make_shared<SimpleDynamicSlip>());
    }
}

StateEstimatorNode::~StateEstimatorNode() {
    kalmanTimeLogger_.saveFile();
}

void StateEstimatorNode::imuCallback(const sensor_msgs::Imu::ConstPtr& msg) { 
    data_manager_->addImuData(msg); 
}

void StateEstimatorNode::slamCallback(const nav_msgs::Odometry::ConstPtr& msg) {
    data_manager_->addSlamData(msg);
}

void StateEstimatorNode::carSensorCallback(const egn_messages::CarSensors::ConstPtr& msg) {
    data_manager_->addWheelSpeedData(msg);
}

void StateEstimatorNode::gpsCallback(const sensor_msgs::NavSatFix::ConstPtr& msg) {
    data_manager_->addGpsData(msg);
}

void StateEstimatorNode::controlOutputCallback(const egn_messages::DVControlOutput::ConstPtr& msg) {
    data_manager_->addControlOutputData(msg);
}

void StateEstimatorNode::executeFilter() {
    // predict the state
    kalman_filter_->predict(*state_, 1.0 / updateRate_, *data_manager_);

    // correct the state, the kalmanfilter will only correct the state if the sensor data is available
    kalman_filter_->correct(*state_, *data_manager_);
}

void StateEstimatorNode::publishStateEstimate() {
    // publish the state estimation
    cogPosPublisher_.publish(state_->state2Odometry(0.0));
    frontAxelPublisher_.publish(state_->state2Odometry(carParameter_.car.lf));

    nav_msgs::Odometry rearAxel = state_->state2Odometry(carParameter_.car.lr);
    rearAxelPublisher_.publish(rearAxel);
    publishWorldFrameTransform(rearAxel);

    stateEstimatePublisher_.publish(state_->state2StateEstimate());
}

void StateEstimatorNode::publishWorldFrameTransform(const nav_msgs::Odometry& odom)
{
	static tf::TransformBroadcaster br;
	tf::Transform                   transform;
	transform.setOrigin(tf::Vector3(odom.pose.pose.position.x, odom.pose.pose.position.y, 0.0));

	double yaw = OdometryHandler::get2dYaw(odom.pose.pose.orientation);

	if (std::isnan(yaw)) {
		return;
	}

	transform.setRotation(OdometryHandler::get2dQuaternion(yaw));

	br.sendTransform(tf::StampedTransform(transform, ros::Time::now(), "world", "car_base"));

}

// node should run at the specified update rate
void StateEstimatorNode::run() {
    kalmanTimeLogger_.setStartTime();
    executeFilter();
    kalmanTimeLogger_.setEndTime();
    publishStateEstimate();
}
    