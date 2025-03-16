function [a] = model_acceleration(x, IMU_1, IMU_2, IMU_3)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    w = x(5:7); v = x(8:10); 
    
    global IMU_select

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end
    
    %% average acceleration (specific force)
    a = zeros(3,1);
    %%% average specific force
    if IMU_select(1) == 1 % only add alive IMUs to average
        a = a + IMU_1(1:3,1) - cross(w, cross(w, param.d1)); % correction for centrifugal force
    end
    if IMU_select(2) == 1
        a = a + IMU_2(1:3,1) - cross(w, cross(w, param.d2));
    end
    if IMU_select(3) == 1
        a = a + IMU_3(1:3,1) - cross(w, cross(w, param.d3));
    end
    a = a / norm(IMU_select, 1); % divide by number of alive IMUs

end

