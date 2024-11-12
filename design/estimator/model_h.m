function [z] = model_h(x)
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % get parameters
    model_params

    % rates
    W = w; % if sensor/rocket alignment is perfect. Use S_s otherwise

    % magnetic field model
    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = quaternion_rotmatrix(q);
    M = 


    % atmosphere model
    [P, T, rho, mach_local] = model_airdata(alt, g, air_gamma, air_R, air_atmosphere);

    % Aerodynamics
    airspeed = norm(v);
    p_dyn = rho/2*airspeed^2;
    Ma = airspeed / mach_local; % remove if not needed

    % forces
    force_aero = zeros(3,1);

    %%% accelerations %% not used
    %%% A =  % include centrifugal correction. Include lift through non-zero side velocities    

    z = [W, M, P, T];
end