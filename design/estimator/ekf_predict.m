function [x_new, P_new] = ekf_predict(x, P, u, Q, step)
    % Computes EKF prediction step.
    % Inputs: estimates x, P; control u; 
    % Input parameters: weighting Q; time difference to last compute step; 
    % Outputs: new estimates x, P

    %% Prediction
    % computes a-priori state and covariance estimates
    % Uses discrete-time dynamics and analytical Jacobian
    
    %%% discrete dynamics update
    [x_pred] = model_dynamics(step, x, u); 

    %%% discrete Jacobian: F = df/dx
    F = jacobian(@model_dynamics, step, x, u); 

    %%% discrete covariance
    P_pred = F * P * F' + step * Q;

    %%% return a-priori estimates
    x_new = x_pred; P_new = P_pred;
end