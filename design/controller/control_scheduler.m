function [K] = control_scheduler(table, variables)
    % determines feedback gain from states. Interpolates from look-up table
    % input: full state x
    % output: K = [phi, p, delta, pre]

    dynamicpressure = variables(1); canardcoeff = variables(2);
    
    %% Load table
    Ks = table.Ks;
    P_mesh = table.P_mesh;
    C_mesh = table.C_mesh;

    %% Interpolate table
    K = zeros(1,4);
    for i=1:4
        %%% interpolate linearly between design points, output 0 if state outside of table
        K(i) = interp2(P_mesh, C_mesh, Ks(:,:,i), canardcoeff, dynamicpressure, 'linear', 0); 
    end
end

