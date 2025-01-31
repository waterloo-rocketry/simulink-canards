## classes

The *StateEstimatorNode* manages everything to have a central place for everyting that is happening. Each sensor gets it's own measurement model and you have to select one prediction model.

The *SensorDataManager* stores the most recent data from each message for the measurement models to use.

The *State* class holds the vector with the current state and getter and setter functions and an enum at what position which value is located. It is important to use this enum everywhere in the code in order to make it easy to add, remove or swap states of the vector. The *typedefs* also need to be set to the right size.

The *KalmanFilter* does the actual estimation part. Each state has an uncertenty associated with it (P). Each sensor has it's own noise covariance (R) and it's own jacobian (H) function the same is true for the prediction model (Q, F). First, the prediction model is called with a fixed frequency of 200Hz. This uses the model to predict the new state and then it updates the covariance matrix P. After that, comes the correction. For every sensor that has new data, the measurement function is calculated meaning we calculate for the current state what the sensor should be reading. Then with all the uncertainty and jacobian matrices, we calculate the optimal gains how to correct each state to fit the measurements.

The *PredictionModel* implements some kind of model how the states should change over time. The most simple one could be to just integrate all the states meaning the position is the integral of velocity, velocity the integral of acceleration and yaw the intagral of yawrate. This can and should be as detailed as you can validate and calculate within a reasonable ammount of time. This can improve the accuracy significantly even if you have not the most accurate or high frequency sensors.

The *MeasurementModel* calculates the difference and jacobian that is needed for the correction step. For every new sensor, this is the most ammount of work that needs to be done to add it in. You have to think about how the state would look like in the sensor reading and then also calculate the derivatives. If there is no new data available, the H matrix just gets filled in with zeros and no correction occurs. 