function [x_new, P_new] = ekf_correct(model_measurement, x, P, y, b, R)
    % Computes EKF correction step.
    % Inputs: estimates x, P; measurement y; sensor bias b;
    % Input parameters: weighting R; 
    % Outputs: new estimates x, P

    %% Correction
    % computes a-posteriori state and covariance estimates
    % Uses discrete-time measurement model and analytical Jacobian

    %%% compute expected measurement and difference to measured values
    y_expected = model_measurement(0,x,b);
    innovation = y - y_expected;

    %%% compute Jacobian: H = dh/dx
    H = jacobian(@model_measurement, 0, x, b); 

    %%% compute Kalman gain (and helper matrices)
    L = H * P * H' + R;
    K = P * H' * inv(L);
    E = eye(length(x)) - K * H;
    
    %%% correct covariance estimate
    P_corr = E * P * E' + K * R * K'; % joseph stabilized

    %%% correct state estimate
    x_corr = x + K * innovation;
    x_corr(1:4) = x_corr(1:4) / norm(x_corr(1:4)); % norm quaternions

    %%% return a-posteriori estimates
    x_new = x_corr; P_new = P_corr;
end