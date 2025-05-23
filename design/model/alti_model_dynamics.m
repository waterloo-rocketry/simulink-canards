function [x_new] = alti_model_dynamics(dt, x, u)
    % Computes state derivative with predictive model. Use ODE solver to compute next state.
    
    %% decomp
    % decompose state vector: [q(4); w(3); vx; alt]
    q = x(1:4); vx = x(5); alt = x(6);

    % decompose input vector
    a = u(1:3); w = u(4:6);

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end
    
    %% compute rotation matrix 
    %%% attitude transformation, inertial to body frame
    S = quaternion_rotmatrix(q);

    %% airdata 
    airdata = model_airdata(alt);

    %% time updates

    % quaternion update
    q_new = quaternion_update(q, w, dt);
    % q_new = q + dt * quaternion_derivative(q, w);
    % q_new = q_new / norm(q_new);
    
    % velocity update 
    v = [vx; 0; 0]; % assume velocity is only rocket-forward
    %%% acceleration specific force    
    v_new = v + dt * (a - cross(w,v) + S*param.g);
    % v_new = v;
    vx_new = v_new(1);

    % altitude update
    v_earth = (S')*v;
    alt_new = alt + dt * v_earth(1);
    
    %% concoct state derivative vector
    x_new = [q_new; vx_new; alt_new];
end