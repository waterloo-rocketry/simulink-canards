function [x_new, P_new] = ekf_algorithm(x, P, u, y, b, t, Q, R, T, step)
    % Computes EKF iteration. Uses model_f for prediction and model_h for correction.
    % use either this or ekf_predict and ekf_correct seperately
    % Inputs: estimates x, P; control u; measurement y; sensor bias b; timecode t
    % Input parameters: weighting Q, R; time difference to last compute T; step size for ODE solver step
    % Outputs: new estimates x, P

    %% Prediction
    % computes a-priori state and covariance estimates.
    % Uses continuous-time model f and solves for state estimate using RK45
    % Solves for covariance estimate using Improved Euler
    
    %%% solve IVP for x: x_dot = f(x, u)
    % [x_pred] = solver_rk4(@model_f, T, step, t, x, u); % RK4
    % [x_pred] = solver_lie_euler(@model_f, T, step, t, x, u); % Lie group & explicit Euler
    [x_pred] = solver_euler(@model_f, T, step, t, x, u); % Explicit Euler

    %%% compute Jacobian: F = df/dx
    F = jacobian(@model_f, t, x, u); 

    %%% solve IVP for P: P_dot = F*P + P*F'+ Q
    %%% Heuns method
    P_dot = F*P + P*F'+ Q;
    % P2 = P + T*P_dot;
    % P_pred = P + T/2*( P_dot + (F*P2 + P2*F'+ Q) ); 
    P_pred = P + T*P_dot;

    %%% a-priori estimates
    x = x_pred; P = P_pred;

    %% Correction
    % computes a-posteriori state and covariance estimates.
    % Uses discrete-time model h
    % Solves for covariance estimate 

    %%% compute expected measurement and difference to measured values
    innovation = y - model_h(t,x,b);

    %%% compute Jacobian: H = dh/dx
    H = jacobian(@model_h, t, x, b); 

    %%% compute Kalman gain
    L = H*P*H' + R;
    K = P*(H') * inv(L);

    %%% correct state and covariance estimates
    x_corr = x + K*innovation;
    x_corr(1:4) = x_corr(1:4)/norm(x_corr(1:4)); % norm quaternions

    % P_corr = (eye(length(x)) - K*H ) * P; % standard form
    P_corr = (eye(length(x))-K*H)*P*(eye(length(x))-K*H)' + K*R*K'; % joseph stabilized

    %% output
    x_new = x_corr;
    P_new = P_corr;

    %% troubleshooting
    % P_pred = P_pred(1:11,1:11) %(1:11,1:11)
    % P_correct = P_new(1:11,1:11)%(1:13,1:11)
    % Kalman = K%(1:11,:)
    % F_jac = F
    % H_jac = H
    % feedback_norm = norm(x_error(1:4))
    % quat_norm = norm(x(1:4))
end