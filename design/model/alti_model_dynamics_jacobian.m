function [J_x] = alti_model_dynamics_jacobian(dt, x, u)
    % Computes state derivative with predictive model. Use ODE solver to compute next state.
    
    %% decomp
    % decompose state vector: [q(4); w(3); vx; alt]
    q = x(1:4); vx = x(5); alt = x(6);
    v = [vx;0;0];

    % decompose input vector
    a = u(1:3); w = u(4:6);

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end

    %% airdata 
    airdata = model_airdata(alt);
    
    %% create empty Jacobian 
    J_x = zeros(length(x), length(x));
    % could also initialize as identity eye(length(x)), as right now all
    % sub-Jacobians have identity on the main diagonal
    
    %% quaternion attitude rows (q, 1:4)
    q_q = quaternion_update_jacobian(q, w, dt);
    % [qdot_q, qdot_w] = quaternion_derivative_jacobian(q,w);
    % q_q = eye(4) + dt * qdot_q;
    % q_w = dt * qdot_w;

    J_x(1:4,1:4) = q_q; % column q (attitude)


    %% velocity rows (vx, 5)
    % v_q = dt * quaternion_rotate_jacobian(quaternion_inv(q), param.g);
    v_q = dt * quaternion_rotate_jacobian(q, param.g);
    v_v = 1;

    J_x(5, 1:4) = v_q(1, :); % column q
    J_x(5, 5) = v_v; % column v


    %% altitude row (alt, 6)
    % r_q = dt * quaternion_rotate_jacobian(q, v);
    r_q = dt * quaternion_rotate_jacobian(quaternion_inv(q), v);
    alt_q = r_q(1,:); % only use altitude from position vector

    r_v = dt * quaternion_rotmatrix(quaternion_inv(q));
    alt_v = r_v(1,:);
    
    alt_alt = 1;

    J_x(6,1:4) = alt_q; % column q
    J_x(6, 5) = alt_v(1,1); % column v
    J_x(6, 6) = alt_alt; % column alt


end