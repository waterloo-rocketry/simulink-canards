function [a] = model_acceleration(x, IMU_1, IMU_2, sensor_select)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    w = x(5:7); v = x(8:10); 

    %% load parameters
    persistent param
    if isempty(param)
        param = coder.load("model/model_params.mat");
    end
    
    %% average acceleration (specific force)
    a = zeros(3,1);
    %%% average specific force
    if sensor_select(1) == 1 && sensor_select(2) == 1 % average if both IMUs are alive
        a = (IMU_1(1:3,1) - cross(w, cross(w, param.d1)) + ... 
            IMU_2(1:3,1) - cross(w, cross(w, param.d2)) ) / 2;       
    elseif sensor_select(1) == 1 
        a = a + IMU_1(1:3,1) - cross(w, cross(w, param.d1)); % correction for centrifugal force
    elseif sensor_select(2) == 1
        a = a + IMU_2(1:3,1) - cross(w, cross(w, param.d2));
    end

end

