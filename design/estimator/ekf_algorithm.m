function [x, P] = ekf_algorithm(x, P, b, t, T, IMU_1, IMU_2, cmd, encoder, AHRS)
    % Computes EKF iteration. Uses model_f for prediction and model_h for correction.
    % Inputs: estimates x, P; control u; measurement y; sensor bias b; timecode t
    % Input parameters: weighting Q, R; time difference to last compute T; 
    % Outputs: new estimates x, P

    global IMU_select 

    %% Prediction step
    %%% Q is a square 13 matrix, tuning for prediction E(noise)
    %%% x = [   q(4),           w(3),           v(3),      alt(1), Cl(1), delta(1)]
    Q = diag([ones(1,4)*1e-9, ones(1,3)*1e0, ones(1,3)*1e-3, 1e-2,  0, 0.2]);
    
    u.accel = model_acceleration(x, IMU_1, IMU_2);
    u.cmd = cmd;
    [xhat, Phat] = ekf_predict(@model_dynamics, @model_dynamics_jacobian, x, P, u, Q, T);
    x = xhat; P = Phat;

    %% Correction step(s), sequential for each IMU
    %%% R is a square matrix (size depending on amount of sensors), tuning for measurement E(noise)
    
    % Encoder
    if 0
        %%% y = [enc(1)]
        R = 0.01;
        [xhat, Phat] = ekf_correct(@model_meas_encoder, @model_meas_encoder_jacobian, x, P, encoder, 0, R);
        x = xhat; P = Phat;
    end
    
    % IMU 1 (MTi630)
    if IMU_select(1) == 1 % only correct with alive IMUs
        %%% y = [   W(3),          Mag(3),      P(1)]
        R = diag([ones(1,3)*1e-6, ones(1,3)*2e-3, 2e1]);

        [xhat, Phat] = ekf_correct(@model_meas_imu, @model_meas_imu_jacobian, x, P, IMU_1(4:end), b.bias_1, R);
        x = xhat; P = Phat;
    end

    % IMU 2 (AltIMU)
    if IMU_select(2) == 1
        %%% y = [   W(3),          Mag(3),      P(1)]
        R = diag([ones(1,3)*2e-6, ones(1,3)*1e-3, 3e1]);

        [xhat, Phat] = ekf_correct(@model_meas_imu, @model_meas_imu_jacobian, x, P, IMU_2(4:end), b.bias_2, R);
        x = xhat; P = Phat;
    end 

    % AHRS (MTi630 internal filter, quaternion output)
    if 0 % only correct with alive IMUs
        %%% y = [   Q(4)    ]
        R = diag(ones(1,4) * 1e-2);
        % the [0;0;0;0] argument should be replaced with the orientation correction 
        % (if AHRS always initilizes the same) or with bias to correct in model
        [xhat, Phat] = ekf_correct(@model_meas_ahrs, @model_meas_ahrs_jacobian, x, P, AHRS, [0;0;0;0], R);
        x = xhat; P = Phat;
    end
end