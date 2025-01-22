function [y] = model_h(t, x, b)
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose bias vector: [b_W(3), M_E(3)]
    b_W = b(1:3); M_E = b(4:6);

    % get parameters
    % z = load("design/estimator/initial_params.mat");
    M_E = [-49.77; -3.11; 18.76];
    S_W = eye(3); % rotation transform from sensor frame to body frame
    S_M = eye(3); % rotation transform from sensor frame to body frame

    % rates
    W = S_W*(w - b_W); % rotation from sensor frame to rocket frame

    % magnetic field model
    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    % S = model_quaternion_rotmatrix(q);
    % M_body = (S)*M_E; % M_E is initial orientation of magnetic field
    M_body = model_quaternion_rotate(q, M_E);
    M = (S_M)*M_body;

    % atmosphere model
    [P, ~, ~, ~] = model_airdata(alt);

    %%% accelerations %% not used
    %%% A =  % include centrifugal correction. Include lift through non-zero side velocities    

    y = [W; M; P];
end