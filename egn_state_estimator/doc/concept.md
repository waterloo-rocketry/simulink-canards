# State estimator concept

## Goal of the State estimator

To propperly control our car, we need to be able to continuously evaluate the state of our car. First of all, the controller needs a current state in order to calculate contorl output to correct the state towards a desired state. That means we need a very accurate high frequency position and velocity estimate.

In our case, we also use the estimated state to guide the slam in finding it's world pose, so the error has to be small enough between two lidar frames.

## Approach

We have a variety of sensors on the car that can all measure different aspects related to the state with various accuracies. The goal is to find the true state, taking into account all the measurements and their noises. In this case, the true behavior of the car is a "blackbox" and we try to approximate it with a model. This model is then corrected every time we get a new sensor reading.

A Kalman filter is an optimal linear state observer, which assumes that white, zero-mean Gaussian noise is added to the measurements and control inputs. This assumption is in general not accurate, but the kalman filter may still be applied successfully for different noise processes and disturbances. The goal of the Kalman Filter is to find the optimal amount of correction for each step to fit the state to the measurements. You don't have to directly measure the state for that. For example if you have a fiixed beacon that you can measure the distance to, the Kalman Filter knows how x and y position play into the distance and can adjust them.

The state vector can contain the intuitive states like the position or velocity, but also parameters, be it fixed like the offset between the start direction and the start zero direction or dynamic like the friction at a part of the track can be estimated as long as they play a roll in a measurement or a prediction model.