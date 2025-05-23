function [u] = alti_model_input(IMU, bias)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% decomp
    A = IMU(1:3,1);
    W = IMU(4:6,1);
    
    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end

    %% bias of gyroscopes
    w = zeros(3,1);
    w = W - bias(4:6);
    
    %% average acceleration (specific force)
    a = zeros(3,1);
    %Use IMU_id = 2, so param.d2
    a = A - cross(w, cross(w, param.d2)); % correction for centrifugal force


    %% input
    u = [a; w];

end

