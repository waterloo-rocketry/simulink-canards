function [y] = model_meas_encoder(t, x, bias)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    delta = x(13);

    %% canard angle
    D = delta;

    %% measurement prediction
    y = D;
end