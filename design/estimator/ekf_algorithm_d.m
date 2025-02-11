function [x_new, P_new] = ekf_algorithm_d(x, P, u, y, b, t, Q, R, T)
    % Computes EKF iteration. Uses model_f for prediction and model_h for correction.
    % Inputs: estimates x, P; control u; measurement y; sensor bias b; timecode t
    % Input parameters: weighting Q, R; time difference to last compute T; 
    % Outputs: new estimates x, P

    %% Prediction
    % computes a-priori state and covariance estimates.
    % Uses discrete-time dynamics and analytical Jacobian
    
    %%% discrete dynamics
    [x_pred] = model_dynamics_discrete(t, x, u, T); 

    %%% discrete Jacobian: F = df/dx
    % F = jacobian(@model_dynamics, t, x, u); 

    %%% discrete covariance
    P_pred = F * P * F' + T*Q;

    %%% a-priori estimates
    x = x_pred; P = P_pred;

    %% Correction
    % computes a-posteriori state and covariance estimates.
    % Uses discrete-time measurement model and analytical Jacobian
    % Solves for covariance estimate 

    %%% compute expected measurement and difference to measured values
    y_expected = model_measurement(t,x,b);
    innovation = y - y_expected;

    %%% compute Jacobian: H = dh/dx
    H = jacobian(@model_measurement, t, x, b); 

    %%% compute Kalman gain
    L = H*P*H' + R;
    K = P*(H') * inv(L);

    %%% correct state and covariance estimates
    x_corr = x + K*innovation;
    x_corr(1:4) = x_corr(1:4)/norm(x_corr(1:4)); % norm quaternions

    P_corr = (eye(length(x))-K*H)*P*(eye(length(x))-K*H)' + K*R*K'; % joseph stabilized

    %% output
    x_new = x_corr;
    P_new = P_corr;

end