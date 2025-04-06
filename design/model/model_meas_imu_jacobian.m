function [J] = model_meas_imu_jacobian(t, x, bias)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose bias matrix: [b_A(3,i); b_W(3, i); M_E(3, i); b_P(1, i)]
    b_W = bias(4:6); M_E = bias(7:9);

  %% Initialize
    % Jacobian is of size: length(measurement) rows, length(x) columns
    % fill with zeros at first
    J = zeros(7, length(x));

    %% rates
    % as W = w + b_W, Jacobian is unity
    W_w = eye(3);

    %% magnetic field model
    % S = quaternion_rotmatrix(q);
    % M = S * M_E; % Earth magnetic field in body frame
    % TODO: add iron corrections
    M_q = quaternion_rotate_jacobian(q, M_E);

    %% atmosphere model
    % [P, ~, ~, ~] = model_airdata(alt);
    P_alt = model_airdata_jacobian(alt);

    %% measurement prediction
    % y = [W; M; P];
    J(1:3, 5:7) = W_w;
    J(4:6, 1:4) = M_q;
    J(7, 11) = P_alt;
end