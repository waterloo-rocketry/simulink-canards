function [x_new, P_new] = ekf_algorithm(x, P, u, y, t, Q, R, T, step)
    % Computes EKF iteration. Uses model_f for prediction and model_h for correction.
    % use either this or ekf_predict and ekf_correct seperately
    % Inputs: estimates x, P; control u; measurement y; timecode t
    % Input parameters: weighting Q, R; time difference to last compute T; step size for ODE solver step
    % Outputs: new estimates x, P

    %% Prediction
    % computes a-priori state and covariance estimates.
    % Uses continuous-time model f and solves for state estimate using RK45
    % Solves for covariance estimate using Improved Euler
    
    %%% solve IVP for x
    %%% x_dot = model_f(x, u);
    % [~,x_solver] = ode45(@(t, x_var)model_f(t, x_var, u), 0:step:T, x); % RK45 (DoPri)
    % x_new = x_solver(end,:)';
    [x_new] = solver_vector(@(t_, x_, u_)model_f(t_, x_, u_), T, step, 0, x, u); % RK4

    %%% compute Jacobians (using complex-step differentiation)
    F = jacobian(@model_f, t, x, u, step); 
    % F2 = jacobian(@model_f, t+T, x_new, u, step);
    
    %%% solve IVP for P
    %%% P_dot = F*P + P*F'+ Q
    P_dot = F*P + P*F'+ Q;
    P2 = P + T*P_dot;
    P_new = P + T/2*( P_dot + (F*P2 + P2*F'+ Q) ); % Heuns method
   
    x = x_new; P = P_new;

    %% Correction
    % computes a-posteriori state and covariance estimates.
    % Uses discrete-time model h
    % Solves for covariance estimate 

    %%% compute expected measurement and difference to measured values
    innovation = y - model_h(t,x,u);

    %%% compute Jacobians (here using closed-form solution)
    H = jacobian(@model_h, t, x, u, step); 

    %%% compute Kalman gain
    S = H*P*H' + R;
    K = P*H' * inv(S);

    %%% correct state and covariance estimates
    x_new = x + K*innovation;
    % P_new = (eye(length(P)) - K*H ) * P;
    P_new = (eye(length(P))-K*H)*P*(eye(length(P))-K*H)' + K*R*K';
end