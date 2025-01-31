#include "ImuMeasurementModel.h"

ImuMeasurementModel::ImuMeasurementModel(bool debug, ros::NodeHandle& nh, ros::NodeHandle& nodehandle)
    : debug_(debug)
{
    nh.param("kalman/imu_acc_noise", accelNoise_, 0.1);
    nh.param("kalman/imu_gyro_noise", gyroNoise_, 0.1);

    H_(0, State::accX) = 1.0;
    H_(1, State::accY) = 1.0;
    H_(2, State::yawRate) = 1.0;

    setR();

    if (debug_) {
        errorPublisher_ = nodehandle.advertise<egn_messages::StateMeasurement>("SE_Debug/imu_error", 1);
    }
}

void ImuMeasurementModel::setR()
{
    R_.diagonal() << accelNoise_, accelNoise_, gyroNoise_;
}

int ImuMeasurementModel::fillDiffVector(VectorState& state, SensorDataManager& data_manager,
                                               Eigen::VectorXd& measurementDiff,
                                               int currentMeasurementRow) const
{
    if (dataAvailable_) {
        // Get the current measurement
        Eigen::Matrix<double, 3, 1> data = data_manager.getImuData();

        // Calculate the model measurement
        Eigen::Matrix<double, 3, 1> model_measurement;
        model_measurement(0) = state(State::accX);
        model_measurement(1) = state(State::accY);
        model_measurement(2) = state(State::yawRate);

        // fill the measurement vector with the difference
        Eigen::Matrix<double, 3, 1> difference = data - model_measurement;
        measurementDiff.block(currentMeasurementRow, 0, 3, 1) = difference;
        
        if (debug_) {
            egn_messages::StateMeasurement error_msg;
            error_msg.header.stamp = ros::Time::now();
            error_msg.header.frame_id = "imu_error";
            error_msg.imu_accx = difference(0);
            error_msg.imu_accy = difference(1);
            error_msg.imu_yawrate = difference(2);
            errorPublisher_.publish(error_msg);
        }
        return 3;
    }  // else the vector is already zero
    return 0;
}

void ImuMeasurementModel::adjustH(VectorState& state, Eigen::Matrix<double, Eigen::Dynamic, StateSize>& H, SensorDataManager& data_manager, int currentMeasurementRow)
{
    if (dataAvailable_) {
        // fill the rows of H with the Imu jacobian starting from the currentMeasurementRow
        H.block(currentMeasurementRow, 0, 3, StateSize) = H_;
    } // else: H is already filled with zeros
}

void ImuMeasurementModel::adjustR(Eigen::MatrixXd& R, SensorDataManager& data_manager,
                                  int currentMeasurementRow) const
{
    if (dataAvailable_) {
        // fill the rows of R with the Imu noise starting from the currentMeasurementRow
        R.block(currentMeasurementRow, currentMeasurementRow, 3, 3) = R_;
    } // else: R is already filled with zeros
}
