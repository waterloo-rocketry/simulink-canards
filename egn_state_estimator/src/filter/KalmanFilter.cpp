#include "KalmanFilter.h"

KalmanFilter::KalmanFilter() {}

KalmanFilter::~KalmanFilter() {}

void KalmanFilter::setPredictionModel(std::shared_ptr<PredictionModel> prediction_model)
{
    prediction_model_ = prediction_model;
    P_ = prediction_model->getQ();
    P_(State::ca, State::ca) = 1.0;
    P_(State::gpsHeadingOffset, State::gpsHeadingOffset) = 10.0;
}

void KalmanFilter::addMeasurementModel(std::shared_ptr<MeasurementModel> measurement_model)
{
    measurement_models_.push_back(measurement_model);
}

void KalmanFilter::predict(State& state, double dt, SensorDataManager& data_manager)
{
    VectorState stateVector = state.getStateVector();
    if (data_manager.isControlOutputDataAvailable()) {
        Eigen::MatrixXd control_output_data = data_manager.getControlOutputData();
        prediction_model_->setControlInputs(control_output_data);
    }
    state.setStateVector(prediction_model_->predict(stateVector, dt));
    MatrixState F = prediction_model_->getJacobian(stateVector, dt);
    MatrixState Q = prediction_model_->getQ();
    P_ = F * P_ * F.transpose() + Q;
}

void KalmanFilter::correct(State& state, SensorDataManager& data_manager)
{
    int numMeas = 0;
    for (auto& measurement_model : measurement_models_) {
        // check if the data is available
        numMeas += measurement_model->isDataAvailable(data_manager);
    }

    // check if there are no measurements
    if (numMeas == 0) {
        return;
    }

    VectorState stateVector = state.getStateVector();
    Eigen::Matrix<double, Eigen::Dynamic, StateSize> H = Eigen::Matrix<double, Eigen::Dynamic, StateSize>::Zero(numMeas, StateSize);
    Eigen::MatrixXd R = Eigen::MatrixXd::Zero(numMeas, numMeas);
    Eigen::VectorXd measurementDiff = Eigen::VectorXd::Zero(numMeas);
    //Eigen::Matrix<double, 7, 7> debugMatrix = Eigen::Matrix<double, 7, 7>::Zero();

    int currentMeasurementRow = 0;

    for (auto& measurement_model : measurement_models_) {

        // adjust the H and R matrices based on the data availability
        measurement_model->adjustH(stateVector, H, data_manager, currentMeasurementRow);
        measurement_model->adjustR(R, data_manager, currentMeasurementRow);

        // Fill diff vector
        currentMeasurementRow += measurement_model->fillDiffVector(stateVector, data_manager, measurementDiff, currentMeasurementRow);
    }

    // calculate the kalman gain
    Eigen::MatrixXd S = H * P_ * H.transpose() + R;
    
    Eigen::Matrix<double, StateSize, Eigen::Dynamic> K = P_ * H.transpose() * S.inverse();

    // correct the state
    VectorState stateUpdate = state.getStateVector() + K * measurementDiff;
    state.setStateVector(stateUpdate);

    // update the covariance matrix
    P_ = (MatrixState::Identity() - K * H) * P_;
}