function [xhat, Phat, controller_input, bias_1, bias_2] = estimator_module(timestamp, IMU_1, IMU_2, cmd, encoder, AHRS)
    % Top-level estimator module. Calls EKF algorithm.
    % Inputs: concocted measurement and output vectors with multiple sensors. Not yet fully supported, work in progress
    % IMU = struct of IMUi = [accel; omega; mag; baro] 
    
    persistent x P t b flight_phase; % remembers x, P, t from last iteration
    global IMU_select 
    
    %% settings
    IMU_select = [1; 1]; % select IMUs, 1 is on, 0 is off
    idle_time = 5; % wait time to handover

    %% initialize at beginning
    xhat = zeros(13,1); Phat = zeros(13); bias_1 = zeros(10, 1); bias_2 = zeros(10, 1);
    if isempty(x)
        x = xhat; P = Phat; b.bias_1 = bias_1; b.bias_2 = bias_2;
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
        [xhat, bias_1, bias_2] = pad_filter(IMU_1, IMU_2);
        x = xhat; b.bias_1 = bias_1; b.bias_2 = bias_2;
    end 

    %% EKF iteration
    if flight_phase == 0 % in flight
        [xhat, Phat] = ekf_algorithm(x, P, b, t, T, IMU_1, IMU_2, cmd, encoder, AHRS);
        x = xhat; P = Phat;
    end
    
    %% Controller post processing
    controller_input = projector(x);

end