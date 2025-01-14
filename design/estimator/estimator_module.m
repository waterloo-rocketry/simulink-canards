function [xhat, Phat] = estimator_module(timestamp, omega, mag, accel, baro, cmd)
    % Top-level estimator module. Calls EKF algorithm.
    % Inputs: concocted measurement and output vectors with multiple sensors. Not yet fully supported, work in progress
    % omega = [wS1; wS2; ...], mag = [magS1; magS2; ...], accel = [accelS1; accelS2; ...]
    % baro = [PS1; TS1; PS2; TS2; ...]
    % cmd = [CMDservo1; CMDservo2; ...]
    
    persistent x P t; % remembers x, P, t from last iteration

    %% initialize at beginning
    if isempty(P)
        x = initializor([omega;mag;accel;baro]);
        P = eye(length(x));
        if timestamp >= 0.005
            t = timestamp-0.005;
        else 
            t = 0;
        end
    end 
    
    %% concoct y and u
    y = [omega; mag; baro];
    u = [cmd; accel];

    %% set parameters for EKF
    step = 0.005; % step size for RK4 and Jacobian
    T = timestamp - t; % end time for RK4 and Improved Euler
    t = timestamp;
    
    %%% Q is a square 13 matrix, tuning for prediction E(noise)
    %%% x = [   q(4),           w(3),           v(3),      alt(1), Cl(1), delta(1)]
    Q = diag([ones(1,4)*1e-4, ones(1,3)*1e1, ones(1,3)*1e1, 100,  0.001, 0.001]);
    % Q()
    
    %%% R is a square 7*a matrix (a amount of sensors), tuning for measurement E(noise)
    %%% y = [   W(3),          Mag(3),     P(1)]
    R = diag([ones(1,3)*1e-4, ones(1,3)*1e2, 1e-1]);

    %% compute new estimate with EKF
    [xhat, Phat] = ekf_algorithm(x, P, u, y, t, Q, R, T, step);
    x = xhat; P = Phat;
end

