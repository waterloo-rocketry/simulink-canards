function [xhat] = estimator_module(timestamp, omega, mag, accel, baro, cmd)
    % Top-level estimator module. Calls EKF algorithm.
    % Inputs: concocted measurement and output vectors with multiple sensors. Not yet fully supported, work in progress
    % omega = [wS1; wS2; ...], mag = [magS1; magS2; ...], accel = [accelS1; accelS2; ...]
    % baro = [PS1; TS1; PS2; TS2; ...]
    % cmd = [CMDservo1; CMDservo2; ...]
    
    persistent x P t; % remembers x, P, t from last iteration

    % initialize at beginning
    if isempty(P)
        x = ekf_initialization([omega;mag;accel;baro]);
        P = zeros(length(x));
    end 
    
    %% concoct y and u

    y = [omega; mag; baro];
    u = [cmd; accel];

    %% set parameters for EKF
    step = 0.0001; % step size for RK45 and Jacobian
    T = timestamp - t; % end time for RK45 and Improved Euler
    t = timestamp;

    Q = diag([ 1e-3*ones(1,4), 10,10,10, 0.1,0.1,0.1, 1,  0.01, 1e-4]); % Square 13 matrix, tuning for prediction E(noise)
    %%% x = [q(4), w(3), v(3), alt(1), Cl(1), delta(1)]

    R = diag([1e-3*ones(1,3), 1*ones(1,3), 0.01, 0.1]); % Square 8*a matrix (a amount of sensors), tuning for measurement E(noise)
    %%% y = [W(3), Mag(3), P(1), T(1)]

    % compute new estimate with EKF
    [x, P] = ekf_algorithm(x, P, u, y, t, Q, R, T, step);
    xhat = x;
end

