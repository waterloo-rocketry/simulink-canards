function [K] = control_scheduler(flight_cond)
    % determines feedback gain from states. Interpolates from look-up table
    % input: full state x
    % output: K = [phi, p, delta, pre]

    dynamicpressure = flight_cond(1); canardcoeff = flight_cond(2);
    canardcoeff = 4; % temporary overwrite

    persistent table; 

    if isempty(table)
        table = load("controller\gains.mat", "Ks", "P_mesh", "C_mesh");
    end
    
    %% Load table
    Ks = table.Ks;
    P_mesh = table.P_mesh;
    C_mesh = table.C_mesh;

    %% Interpolate table
    K = zeros(1,3);
    for i=1:3
        %%% bilinear interpolation between design points, output 0 if state outside of table
        K(i) = interp2(P_mesh, C_mesh, Ks(:,:,i), canardcoeff, dynamicpressure, 'linear', 0); 
    end
end

