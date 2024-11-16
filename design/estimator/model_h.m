function [z] = model_h(x)
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % get parameters
    model_params

    % rates
    W = S_SW*w; % rotation from sensor frame to rocket frame

    % magnetic field model
    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = model_quaternion_rotmatrix(q);
    M = S_SM*S*[1;0;0]; % taking [1;0;0] as initial orientation of magnetic field

    % atmosphere model
    [P, T, ~, ~] = model_airdata(alt, g, air_gamma, air_R, air_atmosphere);

    %%% accelerations %% not used
    %%% A =  % include centrifugal correction. Include lift through non-zero side velocities    

    z = [W, M, P, T];
end