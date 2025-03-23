function [xhat, Phat, controller_input, bias_1, bias_2, bias_3] = estimator_module(timestamp, IMU_1, IMU_2, IMU_3, cmd, encoder)
    % Top-level estimator module. Calls EKF algorithm.
    % Inputs: concocted measurement and output vectors with multiple sensors. Not yet fully supported, work in progress
    % IMU = struct of IMUi = [accel; omega; mag; baro] 
    
    persistent x P t b init_phase; % remembers x, P, t from last iteration
    global IMU_select 
    
    %% settings
    IMU_select = [1; 0; 1]; % select IMUs, 1 is on, 0 is off
    idle_time = 5; % wait time to handover

    %% initialize at beginning
    xhat = zeros(13,1); Phat = zeros(13); bias_1 = zeros(10, 1); bias_2 = zeros(10, 1); bias_3 = zeros(10, 1);
    if isempty(x)
        x = xhat; P = Phat; b.bias_1 = bias_1; b.bias_2 = bias_2; b.bias_3 = bias_3;
        init_phase = 1;
        if timestamp >= 0.005
                t = timestamp-0.005;
        else 
                t = 0;
        end
    end
    
    %% timecode
    T = timestamp - t; % time step size for integrators
    t = timestamp;
    
    %% Pad filter iteration
    if init_phase ~= 0 % only before ignition
        [xhat, bias_1, bias_2, bias_3] = pad_filter(IMU_1, IMU_2, IMU_3);

        if t >= idle_time % mock for flight phase
            init_phase = 0;
        else
            x = xhat; b.bias_1 = bias_1; b.bias_2 = bias_2; b.bias_3 = bias_3;
        end
    end 

    %% EKF iteration
    if init_phase == 0 % in flight
        % [xhat, Phat] = ekf_algorithm(x, P, u, y, b, t, Q, R, T);

        % Prediction step
        %%% Q is a square 13 matrix, tuning for prediction E(noise)
        %%% x = [   q(4),           w(3),           v(3),      alt(1), Cl(1), delta(1)]
        Q = diag([ones(1,4)*1e-10, ones(1,3)*1e2, ones(1,3)*2e-2, 1e-2,  1, 10]);
        
        u.accel = model_acceleration(x, IMU_1, IMU_2, IMU_3);
        u.cmd = cmd;
        [xhat, Phat] = ekf_predict(@model_dynamics, x, P, u, Q, T);
        x = xhat; P = Phat;

        % Correction step, sequential for each IMU
        %%% R is a square matrix (size depending on amount of sensors), tuning for measurement E(noise)
        
        %%% y = [enc(1)]
        R = 0.01;
        [xhat, Phat] = ekf_correct(@model_meas_encoder, x, P, encoder, 0, R);
        x = xhat; P = Phat;

        if IMU_select(1) == 1 % only correct with alive IMUs
            %%% y = [   W(3),          Mag(3),     P(1), AHRS filtered quat]
            R = diag([ones(1,3)*1e-5, ones(1,3)*5e-2, 2e1, ones(1,4)*1e-2]);

            [xhat, Phat] = ekf_correct(@model_meas_imu1, x, P, IMU_1(4:end), b.bias_1, R);
            x = xhat; P = Phat;
        end

        if IMU_select(2) == 1
            %%% y = [   W(3),          Mag(3),     P(1)]
            R = diag([ones(1,3)*1e-5, ones(1,3)*1e-1, 2e1]);

            [xhat, Phat] = ekf_correct(@model_meas_imu2, x, P, IMU_2(4:end), b.bias_2, R);
            x = xhat; P = Phat;
        end

        if IMU_select(3) == 1
            %%% y = [   W(3),          Mag(3),     P(1)]
            R = diag([ones(1,3)*2e-5, ones(1,3)*1e-1, 3e1]);

            [xhat, Phat] = ekf_correct(@model_meas_imu3, x, P, IMU_3(4:end), b.bias_3, R);
            x = xhat; P = Phat;
        end 
    end
    

    %% Controller post processing
    controller_input = post_processor(xhat);

end