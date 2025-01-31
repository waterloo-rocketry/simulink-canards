# How to add a new sensor

First you have to increase the number of measurements by the number of measurements the new sensor provides. In general, it makes sense to add all measurements individually and not combine them beforehand, so the filter has more flexibility to evaluate them differently. Two rgs sensors for example should be added as two different measurements instead of calculating an average speed.

The noise estimates could come from data sheets, but can also be use as tuning parameters to weight different sensors differently. Large numbers mean high expected noise. When filling the R matrix, you could also use dynamic noise estimates, for example we might want to weight the wheelspeeds less if we have high accelerations because we expect wheelslip.

Then you just need to initialize the measurement model in the StateEstimatorNode.cpp and add the subscriber if it isn't already in there

For debugging you should also adjust the StateMeasurement message and add a publisher.