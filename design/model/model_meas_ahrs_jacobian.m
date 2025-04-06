function [J] = model_meas_ahrs_jacobian(t, x, bias)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    % q = x(1:4);

    %% Initialize
    % Jacobian is of size: length(measurement) rows, length(x) columns
    % fill with zeros at first
    J = zeros(4, length(x));

    %% Jacobian of Quaternion
    % as Q = q, Jacobian is unity
    Q_q = eye(4);
    
    %% Jacobian output
    J(1:4, 1:4) = Q_q;
end