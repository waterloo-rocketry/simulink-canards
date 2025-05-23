function [xhat, Phat, bias] = alti_module(timestamp, IMU, GPS)
    % Top-level estimator module. Calls EKF algorithm.
    % Inputs: concocted measurement and output vectors with multiple sensors. Not yet fully supported, work in progress
    % IMU = struct of IMUi = [accel; omega; mag; baro] 
    
    persistent x P t b flight_phase; % remembers x, P, t from last iteration
    
    %% settings
    idle_time = 3; % wait time to handover

    %% initialize at beginning
    xhat = zeros(6,1); Phat = zeros(6); bias = zeros(10, 1);
    if isempty(x)
        x = xhat; P = Phat; b = bias;
        flight_phase = 1;
        if timestamp >= 0.005
                t = timestamp-0.005;
        else 
                t = 0;
        end
    end
    
    %% timecode
    T = timestamp - t; % time step size for integrators
    t = timestamp;
    
    %% flight phase
    if t >= idle_time % mock for flight phase
            flight_phase = 0;
    end

    %% Pad filter iteration
    if flight_phase ~= 0 % only before ignition
        [xhat, bias] = alti_pad_filter(IMU, GPS);
        x = xhat; b = bias;
    end 

    %% EKF iteration
    if flight_phase == 0 % in flight
        [xhat, Phat] = alti_ekf_algorithm(x, P, b, t, T, IMU, GPS);
        x = xhat; P = Phat;
    end
end