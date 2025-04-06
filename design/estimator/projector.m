function [output] = projector(x)
    % Computes roll state and scheduling variables for controller.
    % Output: vector with (1:3) state, (4:5) flight conditions

    output = zeros(5,1);
    
    %% Roll state
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = quaternion_rotmatrix(q);

    % compute roll angle       
    phi = atan2(S(2,3), S(3,3)); % double check if this is the correct angle
    % note: this has singularities at +- 90° (Zipfel p. 127)
    
    % cat roll state
    output(1:3,:) = [phi; w(1); delta];

    %% scheduling variables
    % calculate air data
    [~, rho, ~] = model_airdata(alt);
    airspeed = norm(v);
    p_dyn = rho/2*airspeed^2;

    output(4:5,:) = [p_dyn; Cl];
end

