function [A,B,C,sys_roll] = model_roll(x)
    % Computes state jacobian for roll dynamics

    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = (1:4); v = x(8:10); alt = x(11); Cl = x(12);

    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = model_quaternion_rotmatrix(q);

    % compute roll angle       
    phi = S(2,3)/S(3,3); % double check if this is the correct angle

    % get parameters
    model_params
   
    % calculate air data
    [~, ~, rho, ~] = model_airdata(alt, g, air_gamma, air_R, air_atmosphere);
    airspeed = norm(v);
    p_dyn = rho/2*airspeed^2;

    % simplified linear roll model
    %%% x_roll = [phi; w; delta]

    A = [0, 1, 0; % roll angle is integral of roll rate
         0, 0, Cl*c_canard*p_dyn/J(1); 
         0, 0, -1/tau]; % 1st order actuator dynamics

    B = [0; 0; 1]; % adjust scaling for servo to canard angle ratio

    C = eye(3); % assume all states are known from estimation

    sys_roll = ss(A,B,C,0);
end