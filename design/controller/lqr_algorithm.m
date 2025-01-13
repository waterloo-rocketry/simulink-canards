function [u] = lqr_algorithm(x, r)
    % Computes control output. Uses gain schedule table and simplified roll model
    % Inputs: full state x, reference signal r
    % Outputs: control input u
    
    %% State
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = model_quaternion_rotmatrix(q);

    % compute roll angle       
    phi = atan2(S(2,3), S(3,3)); % double check if this is the correct angle
    
    % cat roll state
    x_roll = [phi; w(1); delta];

    %% Schedule
    % get gain from schedule
    Ks = lqr_schedule(x);
    K_pre = Ks(4);
    K = Ks(1:3);
    
    %% Feedback law
    u = K*x_roll + K_pre*r; %two degree of freedom, full state feedback
end

