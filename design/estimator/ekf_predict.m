function [x_new, P_new] = ekf_predict(x, P, u, t, Q, T, step)
    % prediction step of the EKF.
    % computes a-priori state and covariance estimates.
    % Uses continuous-time model f and solves for state estimate using RK45
    % Solves for covariance estimate using Heuns method

    % x_dot = model_f(x, u);
    [~,x_solver] = ode45(@(t, x_var)model_f(t, x_var, u), 0:step:T, x); % RK45 (DoPri)
    x_new = x_solver(end,:)';
    % [x_new, ~] = solver_rk4(@(t_, x_, u_)model_f(t_, x_, u_), T, step, 0, x, u); % RK4

    % compute Jacobians (using complex-step differentiation)
    F1 = jacobian(@model_f, t, x, u, 0.001); 
    F2 = jacobian(@model_f, t, x_new, u, 0.001);
    
    % solve IVP for P
    % P_dot = F*P + P*F'+ Q
    P_dot = F1*P + P*F1'+ Q;
    P2 = P + T*P_dot;
    P_new = P + T/2*( P_dot + (F2*P2 + P2*F2'+ Q) ); % Heuns method
end