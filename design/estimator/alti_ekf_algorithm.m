function [x, P] = alti_ekf_algorithm(x, P, b, t, T, IMU, GPS)
    % Computes EKF iteration. Uses model_f for prediction and model_h for correction.
    % Inputs: estimates x, P; control u; measurement y; sensor bias b; timecode t
    % Input parameters: weighting Q, R; time difference to last compute T; 
    % Outputs: new estimates x, P

    %% Prediction step
    %%% Q is a square 13 matrix, tuning for prediction E(noise)
    %%% x = [   q(4),         v(1),  alt(1)]
    Q = diag([ones(1,4)*1e-9, 1e-3, 1e0]);

    u = alti_model_input(IMU, b);
    [xhat, Phat] = ekf_predict(@alti_model_dynamics, @alti_model_dynamics_jacobian, x, P, u, Q, T);
    x = xhat; P = Phat;

    %% Correction step(s), sequential for each IMU
    %%% R is a square matrix (size depending on amount of sensors), tuning for measurement E(noise)
        
    % IMU (AltIMU)
    %%% y = [    Mag(3),     P(1)]
    R = diag([ones(1,3)*1e2, 3e1]);

    [xhat, Phat] = ekf_correct(@alti_model_meas_imu, @alti_model_meas_imu_jacobian, x, P, IMU(7:end), b, R);
    x = xhat; P = Phat;

end