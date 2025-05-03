function [A,B,C,sys_roll] = model_roll(dynamicpressure, canardcoeff)
    % Computes state jacobian for roll dynamics
    
    % get parameters
    persistent param
    if isempty(param)
        param = load("design\model\model_params.mat");
    end

    % simplified linear roll model
    %%% x_roll = [phi; w; delta]
    L_delta = canardcoeff * param.c_canard * dynamicpressure / param.J(1);

    A = [0, 1; % roll angle is integral of roll rate
         0, 0];

    B = [0; L_delta]; % adjust scaling for servo to canard angle ratio

    C = eye(2); % assume all states are known from estimation

    sys_roll = ss(A,B,C,0);
end