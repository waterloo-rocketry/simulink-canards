function [u] = control_algorithm(x, r)
    % Computes control output. Uses gain schedule table and simplified roll model
    % Inputs: full state x, reference signal r
    % Outputs: control input u
    
    persistent table; 

    if isempty(table)
        table = load("controller\gains.mat", "Ks", "P_mesh", "C_mesh");
    end

    %% State
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = quaternion_rotmatrix(q);

    % compute roll angle       
    phi = atan2(S(2,3), S(3,3)); % double check if this is the correct angle
    % note: this has singularities at +- 90° (Zipfel p. 127)
    
    % cat roll state
    x_roll = [phi; w(1); delta];

    %% Gain scheduling
    Ks = zeros(1,4);
    % get gain from schedule
    Ks = control_scheduler(table, x);
    K = Ks(1:3);
    K_pre = Ks(4);
    
    %% Feedback law
    u = K*x_roll + K_pre*r; %two degree of freedom, full state feedback
end

