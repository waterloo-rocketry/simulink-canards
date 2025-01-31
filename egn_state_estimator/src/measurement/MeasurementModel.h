#pragma once

#include "SensorDataManager.h"
#include "filter/State.h"
#include "StateTypeDefs.h"
#include "egn_messages/include/CarParameter.h"

#include "egn_messages/StateMeasurement.h"

#include <Eigen/Dense>
#include <ros/ros.h>

class MeasurementModel
{
  public:
    virtual ~MeasurementModel() = default;

    virtual int fillDiffVector(VectorState& state, SensorDataManager& data_manager,
                                      Eigen::VectorXd& measurementDiff,
                                      int currentMeasurementRow) const = 0;

    // functions to adjust H and R matrices based on data availability
    virtual void adjustH(VectorState& state, Eigen::Matrix<double, Eigen::Dynamic, StateSize>& H, SensorDataManager& data_manager, int currentMeasurementRow) = 0;
    virtual void adjustR(Eigen::MatrixXd& R, SensorDataManager& data_manager, int currentMeasurementRow) const = 0;

    // check for data availability
    virtual int isDataAvailable(SensorDataManager& data_manager) = 0;

  protected:
    bool dataAvailable_;

    ros::Publisher errorPublisher_;

  private:
    virtual void setR() = 0;
};