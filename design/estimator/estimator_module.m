function [xhat, Phat, bias, out] = estimator_module(timestamp, IMU, cmd, encoder)
    % Top-level estimator module. Calls EKF algorithm.
    % Inputs: concocted measurement and output vectors with multiple sensors. Not yet fully supported, work in progress
    % IMU = struct of IMUi = [accel; omega; mag; baro] 
    
    persistent x P t b init_phase; % remembers x, P, t from last iteration
    global IMU_select 
    
    %% settings
    IMU_select = [1; 0,; 0]; % select IMUs, 1 is on, 0 is off
    flight_phase = 5; % acceleration threshold to detect boost phase

    %%% Q is a square 16 matrix, tuning for prediction E(noise)
    %%% x = [   q(4),           w(3),        a(3),              v(3),     alt(1), Cl(1), delta(1)]
    Q = diag([ones(1,4)*1e-12*0, ones(1,3)*1e2, ones(1,3)*1e3, ones(1,3)*1e-1, 1e-2,  10, 10]);
    % Q(1:4, 11) = 10;
    Q = (Q+Q')/2;
    
    %%% R is a square 7*a matrix (a amount of sensors), tuning for measurement E(noise)
    %%% y = [   A(3),           W(3),          Mag(3),       P(1), AHRS filtered quat, enc(1)]
    R = diag([ones(1,3)*1e-2, ones(1,3)*1e-5, ones(1,3)*1e-3, 5e0, ones(1,4)*1e-5, 0.01]);
    R = (R+R')/2;

    %% concoct y and u
    [meas, y] = imu_selector(IMU, IMU_select);
    y = [y; encoder];
    u = [cmd];

    %% initialize at beginning
    xhat = zeros(16,1); Phat = zeros(16); bias = zeros(size(meas)); out = zeros(3,1);
    if isempty(x)
        x = xhat; P = Phat; b = bias;
        init_phase = 1;
        if timestamp >= 0.005
                t = timestamp-0.005;
        else 
                t = 0;
        end
    end
    
    %% Initializor filter iteration
    if init_phase ~= 0 
        [xhat, bias, ~] = init_algorithm(meas);
        if (norm(meas(1:3,1))-9.81) >= flight_phase
            init_phase = 0;
        else
            x = xhat; b = bias;
        end
    end 

    %% EKF iteration
    T = timestamp - t; % time period for integrators
    t = timestamp;

    if init_phase == 0
        % u(2:4) = model_acceleration(x, u(2:end));
        [xhat, Phat] = ekf_algorithm_d(x, P, u, y, b, t, Q, R, T);
        x = xhat; P = Phat; bias = b;
    end
    
    %% troubleshooting
    % timestamp
    % init_phase
end

