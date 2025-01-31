#pragma once

#include <memory>

#include "StateTypeDefs.h"
#include "SensorDataManager.h"
#include "State.h"
#include "measurement/MeasurementModel.h"
#include "prediction/PredictionModel.h"

#include <ros/ros.h>


class KalmanFilter
{
public:
  KalmanFilter();
  ~KalmanFilter();

  void predict(State& state, double dt, SensorDataManager& data_manager);
  void correct(State& state, SensorDataManager& data_manager);
  void setPredictionModel(std::shared_ptr<PredictionModel> prediction_model);
  void addMeasurementModel(std::shared_ptr<MeasurementModel> measurement_model);

private:
    std::shared_ptr<PredictionModel> prediction_model_;
    std::vector<std::shared_ptr<MeasurementModel>> measurement_models_;

    MatrixState P_;

    ros::NodeHandle nh_;
};