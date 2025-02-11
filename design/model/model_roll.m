function [A,B,C,sys_roll] = model_roll(x, dynamicpressure, canardcoeff)
    % Computes state jacobian for roll dynamics
    
    % get parameters
    persistent param
    if isempty(param)
        param = load("design\model\model_params.mat");
    end

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
    if nargin > 1 && isempty(dynamicpressure) == 0
        p_dyn = dynamicpressure;
    end
    if nargin > 1 && isempty(canardcoeff) == 0
       Cl = canardcoeff; 
    end

    % simplified linear roll model
    %%% x_roll = [phi; w; delta]
    L_delta = Cl*param.c_canard*p_dyn/param.J(1);

    A = [0, 1, 0; % roll angle is integral of roll rate
         0, 0, L_delta; 
         0, 0, -1/param.tau]; % 1st order actuator dynamics

    B = [0; 0; 1]; % adjust scaling for servo to canard angle ratio

    C = eye(3); % assume all states are known from estimation

    sys_roll = ss(A,B,C,0);
end