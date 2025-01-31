#include "SlamMeasurementModel.h"

SlamMeasurementModel::SlamMeasurementModel(bool debug, ros::NodeHandle& nh, ros::NodeHandle& nodehandle)
    : debug_(debug)
{
    nh.param("kalman/slam_x_noise", slamXNoise_, 0.1);
    nh.param("kalman/slam_y_noise", slamYNoise_, 0.1);
    nh.param("kalman/slam_yaw_noise", slamYawNoise_, 0.1);

    H_(0, State::x) = 1;
    H_(1, State::y) = 1;
    H_(2, State::yaw) = 1;

    setR();

    if (debug) {
        errorPublisher_ = nodehandle.advertise<egn_messages::StateMeasurement>("SE_Debug/slam_error", 1);
    }
}

void SlamMeasurementModel::setR()
{
    R_.diagonal() << slamXNoise_, slamYNoise_, slamYawNoise_;
}

int SlamMeasurementModel::fillDiffVector(VectorState& state, SensorDataManager& data_manager,
                                               Eigen::VectorXd& measurementDiff,
                                               int currentMeasurementRow) const
{
    if (dataAvailable_) {
        // Get the current measurement
        Eigen::Matrix<double, 3, 1> data = data_manager.getSlamData();
        
        // Calculate the model measurement
        Eigen::Matrix<double, 3, 1> model_measurement;
        model_measurement(0) = state(State::x);
        model_measurement(1) = state(State::y);
        model_measurement(2) = state(State::yaw);

        // fill the measurement vector with the difference
        Eigen::Matrix<double, 3, 1> difference = data - model_measurement;
        measurementDiff.block(currentMeasurementRow, 0, 3, 1) = difference;

        if (debug_) {
            egn_messages::StateMeasurement error_msg;
            error_msg.header.stamp = ros::Time::now();
            error_msg.header.frame_id = "slam_error";
            // transform x and y to local frame
            double x = difference(0) * cos(state(State::yaw)) + difference(1) * sin(state(State::yaw));
            double y = -difference(0) * sin(state(State::yaw)) + difference(1) * cos(state(State::yaw));
            error_msg.slam_x = x;
            error_msg.slam_y = y;
            error_msg.slam_yaw = difference(2);
            errorPublisher_.publish(error_msg);
        }
        return 3;
    } // else the vector is already zero
    return 0;
}

void SlamMeasurementModel::adjustH(VectorState& state, Eigen::Matrix<double, Eigen::Dynamic, StateSize>& H, SensorDataManager& data_manager, int currentMeasurementRow)
{
    if (dataAvailable_) {
        // fill the rows of H with the Slam jacobian starting from the currentMeasurementRow
        H.block(currentMeasurementRow, 0, 3, StateSize) = H_;
    } // else: H is already filled with zeros
}

void SlamMeasurementModel::adjustR(Eigen::MatrixXd& R, SensorDataManager& data_manager,
                                  int currentMeasurementRow) const
{
    if (dataAvailable_) {
        // fill the rows of R with the Slam noise starting from the currentMeasurementRow
        R.block(currentMeasurementRow, currentMeasurementRow, 3, 3) = R_;
    } // else: R is already filled with zeros
}