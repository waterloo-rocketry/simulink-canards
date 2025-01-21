function [K] = control_scheduler(table, x, dynamicpressure, canardcoeff)
    % determines feedback gain from states. Interpolates from look-up table
    % input: full state x
    % output: K = [phi, p, delta, pre]

    % check if state is provided
    if isempty(x) == 0
        % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
        v = x(8:10); alt = x(11); Cl = x(12);
       
        % calculate air data
        [~, ~, rho, ~] = model_airdata(alt);
        airspeed = norm(v);
        p_dyn = rho/2*airspeed^2;
    end 

    % check for optinonal inputs
    if nargin > 2 && isempty(dynamicpressure) == 0
        p_dyn = dynamicpressure;
    end
    if nargin > 2 && isempty(canardcoeff) == 0
       Cl = canardcoeff; 
    end
    
    %% Load table
    Ks = table.Ks;
    P_mesh = table.P_mesh;
    C_mesh = table.C_mesh;

    %% Interpolate table
    K = zeros(1,4);
    for i=1:4
        %%% interpolate linearly between design points, output 0 if state outside of table
        K(i) = interp2(P_mesh, C_mesh, Ks(:,:,i), Cl, p_dyn, 'linear', 0); 
    end
end

