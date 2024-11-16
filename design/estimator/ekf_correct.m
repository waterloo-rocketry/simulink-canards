function [x, P] = ekf_correct(x, P, y, R)
    % Correction step of the EKF.
    % computes a-posteriori state and covariance estimates.
    % Uses discrete-time model h
    % Solves for covariance estimate 

    % compute expected measurement and difference to measured values
    innovation = y - model_h(x);

    % compute Jacobians (here using closed-form solution)
    H = model_H(x);

    % compute Kalman gain
    S = H*P*H' + R;
    K = P*H' * inv(S);

    % correct state and covariance estimates
    x = x + K*innovation;
    P = (eye(length(P)) - K*H ) * P;
end