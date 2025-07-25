function [x, P] = ekf_algorithm(x, P, b, t, T, IMU_1, IMU_2, cmd, encoder, sensor_select)
    % Computes EKF iteration. Uses model_f for prediction and model_h for correction.
    % Inputs: estimates x, P; control u; measurement y; sensor bias b; timecode t
    % Input parameters: weighting Q, R; time difference to last compute T; 
    % Outputs: new estimates x, P
    %#codegen


    %% Prediction step
    %%% Q is a square 13 matrix, tuning for prediction E(noise)
    %%% x = [   q(4),           w(3),         v(3),    alt(1), Cl(1), delta(1)]
    Q = diag([[1,1,1,1]*1e-8, [0.5, 5, 5], [1,1,1]*1e-3, 0.1,  100,  50]);
    
    u.accel = model_acceleration(x, IMU_1, IMU_2, sensor_select(1:2));
    u.cmd = cmd;
    [xhat, Phat] = ekf_predict(@model_dynamics, @model_dynamics_jacobian, x, P, u, Q, T);
    x = xhat; P = Phat;

    %% Correction step(s), sequential for each IMU
    %%% R is a square matrix (size depending on amount of sensors), tuning for measurement E(noise)
     
    % IMU 1 (MTi630)
    if sensor_select(1) == 1 % only correct with alive IMUs
        %%% y = [   W(3),          Mag(3),      P(1)]
        R = diag([[1, 1, 1]*1e-6, [1, 1, 1]*0.1, 5]);

        [xhat, Phat] = ekf_correct(@model_meas_imu, @model_meas_imu_jacobian, x, P, IMU_1(4:end), b.bias_1, R);
        x = xhat; P = Phat;
    end

    % Encoder
    if sensor_select(3) == 1
        %%% y = [enc(1)]
        R = 0.2;
        [xhat, Phat] = ekf_correct(@model_meas_encoder, @model_meas_encoder_jacobian, x, P, encoder, 0, R);
        x = xhat; P = Phat;
    end

    % IMU 2 (AltIMU)
    if sensor_select(2) == 1
        %%% y = [   W(3),          Mag(3),      P(1)]
        R = diag([[1, 1, 1]*1e-6, [1, 1, 1]*0.01, 1]);

        [xhat, Phat] = ekf_correct(@model_meas_imu, @model_meas_imu_jacobian, x, P, IMU_2(4:end), b.bias_2, R);
        x = xhat; P = Phat;
    end 

end