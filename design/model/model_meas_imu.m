function [y] = model_meas_imu(t, x, bias)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose bias matrix: [b_A(3,i); b_W(3, i); M_E(3, i); b_P(1, i)]
    b_W = bias(4:6); M_E = bias(7:9);

    %% load parameters

    %% rates
    W = w + b_W; 

    %% magnetic field model
    S = quaternion_rotmatrix(q);
    M = S * M_E; % Earth magnetic field in body frame
    % TODO: add iron corrections

    %% atmosphere model
    airdata = model_airdata(alt);
    P = airdata.pressure;

    %% measurement prediction
    y = [W; M; P];
end