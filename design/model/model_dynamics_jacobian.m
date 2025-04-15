function [J_x] = model_dynamics_jacobian(T, x, u)
    % Computes state derivative with predictive model. Use ODE solver to compute next state.
    
    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose input vector
    delta_u = u.cmd; a = u.accel;

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end
    
    
    
    %% concoct state derivative vector
    % x_new = [q_new; w_new; v_new; alt_new; Cl_new; delta_new];
end
