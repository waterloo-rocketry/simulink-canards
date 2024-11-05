function [y] = model_h(x)
    % state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % rates
    W = w; % if sensor/rocket alignment is perfect. Introduce non-I rotation matrix otherwise

    % magnetic field model
    M = 

    % accelerations
    A =  % include centrifugal correction. Include lift through non-zero side velocities

    % atmosphere model
    P = 
    T = 

    y = [W, M, A, P, T];
end