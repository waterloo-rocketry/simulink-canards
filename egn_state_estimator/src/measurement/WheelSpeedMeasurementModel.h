#pragma once

#include "MeasurementModel.h"

class WheelSpeedMeasurementModel : public MeasurementModel
{
  public:
    WheelSpeedMeasurementModel(bool debug, ros::NodeHandle& nh, ros::NodeHandle& nodehandle);

    int fillDiffVector(VectorState& state, SensorDataManager& data_manager, Eigen::VectorXd& measurementDiff,
                              int currentMeasurementRow) const override;

    void adjustH(VectorState& state, Eigen::Matrix<double, Eigen::Dynamic, StateSize>& H, SensorDataManager& data_manager, int currentMeasurementRow) override;
    void adjustR(Eigen::MatrixXd& R, SensorDataManager& data_manager, int currentMeasurementRow) const override;

    int isDataAvailable(SensorDataManager& data_manager) override
    {
        dataAvailable_ = data_manager.isWheelSpeedDataAvailable();
        if (dataAvailable_) {
          return 2;
        }
        return 0;
    }

  private:
    void setR() override;

    bool debug_;

    CarParameter carParameter_;

    double wheelSpeedNoise_ = 0.1;
    
    Eigen::Matrix<double, 2, StateSize> H_ = Eigen::Matrix<double, 2, StateSize>::Zero();
    Eigen::Matrix<double, 2, 2> R_;
    
};