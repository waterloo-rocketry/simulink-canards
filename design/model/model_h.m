function [y] = model_h(t, x, u)
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % get parameters
    % model_params
    k = load("design/model/model_params.mat");
    z = load("design/estimator/initial_params.mat");

    % rates
    W = k.S_W*w; % rotation from sensor frame to rocket frame

    % magnetic field model
    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = model_quaternion_rotmatrix(q);
    M = k.S_M'*S'*z.M_E; % M_E is initial orientation of magnetic field

    % atmosphere model
    [P, ~, ~, ~] = model_airdata(alt);

    %%% accelerations %% not used
    %%% A =  % include centrifugal correction. Include lift through non-zero side velocities    

    y = [W; M; P];
end