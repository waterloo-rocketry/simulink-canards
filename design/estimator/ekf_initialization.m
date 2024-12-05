function [x_init] = ekf_initialization(meas)
    % Computes inital state and covariance estimate for EKF, and bias values for the IMU
    % Uses all available sensors: Gyroscope W, Magnetometer M,
    % Accelerometer A, Barometer P and T, GPS lon, lat, alt
    
    % decompose measurement vector
    W = meas(1:3); M = meas(4:6); A = meas(7:9); P = meas(10); T = meas(11);

    q = [];
    w = [0; 0; 0];
    v = [0; 0; 0];
    alt = 0;
    Cl = 1.5;
    delta = 0;
    
    x_init = [q;w;v;alt;Cl;delta];
end

