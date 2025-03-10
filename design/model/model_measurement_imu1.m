function [y] = model_measurement_imu1(t, x, b)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose bias matrix: [b_A(3,i); b_W(3, i); M_E(3, i); b_P(1, i)]
    b_W = b(4:6); M_E = b(7:9);


    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end

    %% rates
    W = w + b_W; 

    %% magnetic field model
    S = quaternion_rotmatrix(q);
    M_body = (S)*M_E(:,i); % % Earth magnetic field in body frame
    M(3*(k-1)+1 : 3*k) = M_body; % TODO: add iron corrections

    %% atmosphere model
    [Pk, ~, ~, ~] = model_airdata(alt);
    P(k) = Pk;
    
    %% canard angle
    D = delta;

    %% measurement prediction
    y = [W; M; P; D];
end