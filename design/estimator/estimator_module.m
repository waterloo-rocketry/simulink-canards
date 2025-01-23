function [xhat, Phat, bias, out] = estimator_module(timestamp, omega, mag, accel, baro, cmd)
    % Top-level estimator module. Calls EKF algorithm.
    % Inputs: concocted measurement and output vectors with multiple sensors. Not yet fully supported, work in progress
    % omega = [wS1; wS2; ...], mag = [magS1; magS2; ...], accel = [accelS1; accelS2; ...]
    % baro = [PS1; TS1; PS2; TS2; ...]
    % cmd = [CMDservo1; CMDservo2; ...]
    
    persistent x P t b init_phase; % remembers x, P, t from last iteration
    
    %% initialize at beginning
    xhat = zeros(13,1); Phat = zeros(13); bias = zeros(6,1); out = 0;
    if isempty(x)
        x = zeros(13,1);
        P = zeros(length(x));
        b = zeros(6,1);
        init_phase = 1;
        if timestamp >= 0.005
                t = timestamp-0.005;
        else 
                t = 0;
        end
    end

    if init_phase ~= 0 
        [xhat, bias, ~] = initializor([omega;mag;accel;baro]);
        if norm(accel) >= 10.5
            init_phase = 0;
        else
            x = xhat; b = bias;
        end
    end 

    %% concoct y and u
    y = [omega; mag; baro];
    u = [cmd; accel];

    %% set parameters for EKF
    step = 0.001; % step size for RK4 and Jacobian
    T = timestamp - t; % end time for RK4 and Improved Euler
    t = timestamp;
    
    %%% Q is a square 13 matrix, tuning for prediction E(noise)
    %%% x = [   q(4),           w(3),           v(3),      alt(1), Cl(1), delta(1)]
    Q = diag([ones(1,4)*3e-4, ones(1,3)*5e1, ones(1,3)*2e-1, 1e-2,  0, 0]);
    % Q(1:4, 11) = 10;
    Q = (Q+Q')/2;
    
    %%% R is a square 7*a matrix (a amount of sensors), tuning for measurement E(noise)
    %%% y = [   W(3),          Mag(3),     P(1)]
    R = diag([ones(1,3)*1e-1, ones(1,3)*5e0, 2e1]);
    R = (R+R')/2;

    %% compute new estimate with EKF
    if init_phase == 0
        [xhat, Phat] = ekf_algorithm(x, P, u, y, b, t, Q, R, T, step);
        x = xhat; P = Phat; bias = b;
    end
    
    %% troubleshooting
    % timestamp
    % init_phase
    out = 0;
end

