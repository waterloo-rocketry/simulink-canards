function [xhat, Phat, bias, out] = estimator_module(timestamp, IMU_1, IMU_2, IMU_3, cmd, encoder)
    % Top-level estimator module. Calls EKF algorithm.
    % Inputs: concocted measurement and output vectors with multiple sensors. Not yet fully supported, work in progress
    % IMU_i = [accel; omega; mag; baro] 
    
    persistent x P t b init_phase; % remembers x, P, t from last iteration
    
    %% settings
    IMU = IMU_1; % select IMU
    flight_phase = 5; % acceleration threshold to detect boost phase

    %%% Q is a square 13 matrix, tuning for prediction E(noise)
    %%% x = [   q(4),           w(3),           v(3),      alt(1), Cl(1), delta(1)]
    Q = diag([ones(1,4)*3e-4, ones(1,3)*5e1, ones(1,3)*2e-1, 1e-2,  10, 1]);
    % Q(1:4, 11) = 10;
    Q = (Q+Q')/2;
    
    %%% R is a square 7*a matrix (a amount of sensors), tuning for measurement E(noise)
    %%% y = [   W(3),          Mag(3),     P(1), enc(1)]
    R = diag([ones(1,3)*1e-3, ones(1,3)*5e0, 2e1, 0.1]);
    R = (R+R')/2;

    %% concoct y and u

    accel = IMU(1:3);
    omega = IMU(4:6);
    mag = IMU(7:9);
    baro = IMU(10);

    y = [omega; mag; baro; encoder];
    u = [cmd; accel];


    %% initialize at beginning
    xhat = zeros(13,1); Phat = zeros(13); bias = zeros(9,1); out = zeros(3,1);
    if isempty(x)
        x = zeros(13,1);
        P = zeros(length(x));
        b = zeros(9,1);
        init_phase = 1;
        if timestamp >= 0.005
                t = timestamp-0.005;
        else 
                t = 0;
        end
    end
    
    %% Initializor filter iteration
    if init_phase ~= 0 
        [xhat, bias, ~] = initializor([omega;mag;accel;baro]);
        if (norm(accel)-9.81) >= flight_phase
            init_phase = 0;
        else
            x = xhat; b = bias;
        end
    end 

    %% EKF iteration
    T = timestamp - t; % time period for integrators
    t = timestamp;

    if init_phase == 0
        [xhat, Phat] = ekf_algorithm(x, P, u, y, b, t, Q, R, T);
        x = xhat; P = Phat; bias = b;
    end
    
    %% troubleshooting
    % timestamp
    % init_phase
end

