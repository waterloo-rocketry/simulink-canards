function [output] = projector(x)
    % Computes roll state and scheduling variables for controller.
    % Output: vector with (1:3) state, (4:5) flight conditions

    output = zeros(5,1);
    
    %% Roll state
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % compute roll angle       
    phi = quaternion_to_roll(q); % note: this has singularities at +- 90° (Zipfel p. 127)
    
    % cat roll state
    output(1:3,:) = [phi; w(1); delta];

    %% scheduling variables
    % calculate air data

    airdata = model_airdata(alt);
    airspeed = norm(v);
    p_dyn = 0.5 * airdata.density * airspeed^2;
    
    % cat flight condition
    output(4:5,:) = [p_dyn; Cl];
end

