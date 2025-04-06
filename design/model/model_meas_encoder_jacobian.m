function [J] = model_meas_encoder_jacobian(t, x, bias)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    % delta = x(13);

    %% Initialize
    % Jacobian is of size: length(measurement) rows, length(x) columns
    % fill with zeros at first
    J = zeros(1, length(x));

    %% canard angle
    % as D = delta, Jacobian is unity
    D_delta = 1;

    %% measurement prediction
    J(13) = D_delta;
end