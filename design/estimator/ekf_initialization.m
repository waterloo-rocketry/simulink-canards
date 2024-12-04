function [x_init, P_init, W_bias, M_bias, A_bias] = ekf_initialization(W,M,A,P,T,lon,lat,alt, Q,R)
    % Computes inital state and covariance estimate for EKF, and bias values for the IMU
    % Uses all available sensors: Gyroscope W, Magnetometer M,
    % Accelerometer A, Barometer P and T, GPS lon, lat, alt


end

