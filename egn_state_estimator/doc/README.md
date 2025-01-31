## Prediction Model

The prediction model is a model that predicts the next state based on some inputs. This could range from just integrating the states without any input to a full vehicle model that takes into account the control output and slip conditions to predict the next state. The predict model is called with a regular frequency independent of any sensor or controll input.

We need the partial derivatives for all state members and this is currently done numerically. For better performance and accuracy, this should be done analytically, it's just a bit more complex to derive.

The model has a predict function to calculate the next step for a given dt. A numerical version of the Jacobian function is already in the base class.


## Measurement model

The measurement model transforms the state into sensor measurements. Meaning given some state vector, how should the sensor measurments look like. For many sensors, this is quite straight forward. If an IMU measures the local x-acceleration and x-acceleration is a state, then the measurement function is trivial. For other sensors, this is a bit more complex. The Wheelpeed for example would be

$v_{wheelR} = v_x + yawrate \cdot trackwidth/2$

We also need the partial derivative for all state members. This should be done analytically.

The class inherits from MeasurementModel and implements fillMeasurementVector which fills the two Vectors with the acutal measurement and the measuerment calculated from the state.

Adjust H and R are functions that fill the Jacobian and the noise matrix. All three functions should just fill in 0 values if there is no new data available. The H matrix has one row for each measurements of the sensor and one collumn for each state.