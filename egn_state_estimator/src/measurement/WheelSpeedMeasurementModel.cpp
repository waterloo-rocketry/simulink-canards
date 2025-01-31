#include "WheelSpeedMeasurementModel.h"

WheelSpeedMeasurementModel::WheelSpeedMeasurementModel(bool debug, ros::NodeHandle& nh, ros::NodeHandle& nodehandle)
    : debug_(debug)
{
    nh.param("kalman/wheel_speed_noise", wheelSpeedNoise_, 0.1);

    //H_(2, State::yawRate) = carParameter_.car.centerTireCarWidth / 2;
    //H_(3, State::yawRate) = carParameter_.car.centerTireCarWidth / 2;

    setR();

    if (debug_) {
        errorPublisher_ = nodehandle.advertise<egn_messages::StateMeasurement>("SE_Debug/wheel_speed_error", 1);
    }
}

void WheelSpeedMeasurementModel::setR()
{
    R_.diagonal() << wheelSpeedNoise_, wheelSpeedNoise_;
}

int WheelSpeedMeasurementModel::fillDiffVector(VectorState& state, SensorDataManager& data_manager,
                                               Eigen::VectorXd& measurementDiff,
                                               int currentMeasurementRow) const
{
    if (dataAvailable_) {
        // Get the current measurement
        Eigen::Matrix<double, 2, 1> data = data_manager.getWheelSpeedData().block(2, 0, 2, 1);

        // Calculate the model measurement
        Eigen::Matrix<double, 2, 1> model_measurement;
        model_measurement(0) = (state(State::vX) - carParameter_.car.centerTireCarWidth / 2 * state(State::yawRate)) * (1 + state(State::slipL));
        model_measurement(1) = (state(State::vX) + carParameter_.car.centerTireCarWidth / 2 * state(State::yawRate)) * (1 + state(State::slipR));

        // fill the measurement vector with the wheel speed data
        Eigen::Matrix<double, 2, 1> difference = data - model_measurement;
        measurementDiff.block(currentMeasurementRow, 0, 2, 1) = difference;

        if (debug_) {
            egn_messages::StateMeasurement error_msg;
            error_msg.header.stamp = ros::Time::now();
            error_msg.header.frame_id = "wheel_speed_error";
            error_msg.wheel_speed_l = difference(0);
            error_msg.wheel_speed_r = difference(1);
            errorPublisher_.publish(error_msg);
        }
        return 2;
    }  // else the vector is already zero
    return 0;
}

void WheelSpeedMeasurementModel::adjustH(VectorState& state, Eigen::Matrix<double, Eigen::Dynamic, StateSize>& H, SensorDataManager& data_manager,
                                         int currentMeasurementRow)
{
    if (dataAvailable_) {
        H_(0, State::slipL) = state(State::vX) - carParameter_.car.centerTireCarWidth / 2 * state(State::yawRate);
        H_(1, State::slipR) = state(State::vX) + carParameter_.car.centerTireCarWidth / 2 * state(State::yawRate);
        H_(0, State::vX) = 1 + state(State::slipL);
        H_(1, State::vX) = 1 + state(State::slipR);
        H_(0, State::yawRate) = -carParameter_.car.centerTireCarWidth / 2 * (1 + state(State::slipL));
        H_(1, State::yawRate) = carParameter_.car.centerTireCarWidth / 2 * (1 + state(State::slipR));
        // fill the rows of H with the wheel speed jacobian starting from the currentMeasurementRow
        H.block(currentMeasurementRow, 0, 2, StateSize) = H_;

    } // else: H is already filled with zeros
}

void WheelSpeedMeasurementModel::adjustR(Eigen::MatrixXd& R, SensorDataManager& data_manager,
                                         int currentMeasurementRow) const
{
    if (dataAvailable_) {
        // fill the rows of R with the WheelSpeed noise starting from the currentMeasurementRow
        R.block(currentMeasurementRow, currentMeasurementRow, 2, 2) = R_;
    } // else: R is already filled with zeros
}