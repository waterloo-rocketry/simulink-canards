#pragma once

#include "MeasurementModel.h"

class SlamMeasurementModel : public MeasurementModel
{
  public:
    SlamMeasurementModel(bool debug, ros::NodeHandle& nh, ros::NodeHandle& nodehandle);

    int fillDiffVector(VectorState& state, SensorDataManager& data_manager, Eigen::VectorXd& measurementDiff,
                              int currentMeasurementRow) const override;

    void adjustH(VectorState& state, Eigen::Matrix<double, Eigen::Dynamic, StateSize>& H, SensorDataManager& data_manager, int currentMeasurementRow) override;
    void adjustR(Eigen::MatrixXd& R, SensorDataManager& data_manager, int currentMeasurementRow) const override;

    int isDataAvailable(SensorDataManager& data_manager) override
    {
        dataAvailable_ = data_manager.isSlamDataAvailable();
        if (dataAvailable_) {
          return 3;
        }
        return 0;
    }

  private:
    void setR() override;

    bool debug_;

    double slamXNoise_ = 0.1;
    double slamYNoise_ = 0.1;
    double slamYawNoise_ = 0.1;

    Eigen::Matrix<double, 3, StateSize> H_ = Eigen::Matrix<double, 3, StateSize>::Zero();
    Eigen::Matrix<double, 3, 3> R_ = Eigen::Matrix<double, 3, 3>::Zero();
};