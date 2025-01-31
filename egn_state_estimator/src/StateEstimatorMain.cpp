#include <ros/ros.h>
#include "StateEstimatorNode.h"

#include "egn_shared_algorithms/inc/logger.h"

int main(int argc, char **argv)
{
	ros::init(argc, argv, "egn_state_estimator");

    double updateRate = 250.0;

	StateEstimatorNode stateEstimation(updateRate);
	Logger              logger = Logger("SE");

	logger.Info("started egn_state_estimation node");

	ros::Rate rate(updateRate);
    while (ros::ok()) {
        stateEstimation.run();
        ros::spinOnce();
        rate.sleep();
    }

	return 0;
};
