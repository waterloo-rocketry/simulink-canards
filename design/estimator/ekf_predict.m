function [x_new, P_new] = ekf_predict(x, P, u, Q, T, step)
    % prediction step of the EKF.
    % computes a-priori state and covariance estimates.
    % Uses continuous-time model f and solves for state estimate using RK45
    % Solves for covariance estimate using Improved Euler

    % x_dot = model_f(x, u);
    [~,x_solver] = ode45(@(x_)model_f([x_; u]), 0:step:T, x); % RK45 (DoPri)
    x_new = x_solver(end,:)';

    % compute Jacobians (using complex-step differentiation)
    F1 = jacobian(model_f, [x; u], 0.001); 
    F2 = model_F(x_new, u); 
    
    % P_dot = F*P + P*F'+ Q
    P_new = P + T/2*( (F1*P + P*F1'+ Q) + (F2*P + P*F2'+ Q) ); % improved Euler
end