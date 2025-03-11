function [y] = model_measurement_encoder(t, x, bias)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    delta = x(13);

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end
   
    %% canard angle
    D = delta;

    %% measurement prediction
    y = [D];
end