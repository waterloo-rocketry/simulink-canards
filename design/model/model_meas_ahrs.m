function [y] = model_meas_ahrs(t, x, bias)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4);

    %% filtered quaternion
    Q = q;
    
    %% measurement prediction
    y = [Q];
end