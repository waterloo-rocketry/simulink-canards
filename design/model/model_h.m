function [y] = model_h(t, x, b)
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose bias vector: [b_W(3), M_E(3)]
    b_W = b(1:3); M_E = b(4:6);

    % get parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end

    %% rates
    W = param.S1*(w) + b_W; % rotation from sensor frame to rocket frame

    %% magnetic field model
    %%% compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    % S = quaternion_rotmatrix(q);
    % M_body = (S)*M_E; % M_E is initial orientation of magnetic field
    M_body = quaternion_rotate(q, M_E);
    M = (param.S1)*M_body;

    %% atmosphere model
    [P, ~, ~, ~] = model_airdata(alt);
    
    %% canard angle
    D = delta;

    %% measurement prediction
    y = [W; M; P; D];
end