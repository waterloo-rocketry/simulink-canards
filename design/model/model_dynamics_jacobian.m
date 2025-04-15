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
    
    %% create empty Jacobian 
    J_x = zeros(length(x), length(x));
    % could also initialize as identity eye(length(x)), as right now all
    % sub-Jacobians have identity on the main diagonal
    
    %% quaternion attitude rows (q, 1:4)
    [qdot_q, qdot_w] = quaternion_derivative_jacobian(q,w):
    q_q = eye(4) + T * qdot_q;
    q_w = T * qdot_w;
    J_x(1:4,1:4) = q_q; % column q (attitude)
    J_x(1:4, 5:7) = q_w; % column w (rates)

    %% angular rate rows (w, 5:7)
    % todo: skew symmetric matrix function tilde()
    % todo: torque partial derivatives
    w_w = eye(3) + T * inv(J) * (torque_w - J*tilde(w));
    w_v = T * inv(J) * torque_v;
    w_cl = T * inv(J) * torque_cl;
    w_delta = T * inv(J) * torque_delta;
    J_x(5:7,5:7) = w_w; % column w
    J_x(5:7,8:10) = w_v; % column v
    J_x(5:7,12) = w_cl; % column Cl
    J_x(5:7,13) = w_delta; % column delta

    %% velocity rows (v, 8:10)
    v_q = T * quaternion_rotate_jacobian(q, param.g);
    v_w = T * tilde(v);
    v_v = eye(3) - T * tilde(w);
    J_x(8:10,1:4) = v_q; % column q
    J_x(8:10,5:7) = v_w; % column w
    J_x(8:10,8:10) = v_v; % column v


    %% altitude row (alt, 11)
    r_q = T * quaternion_rotate_jacobian(quaternion_inv(q), v);
    alt_q = r_q(1,:); % only use altitude from position vector
    r_v = T * quaternion_rotmatrix(q);
    alt_v = r_v(1,:);
    % r_r = eye(3);
    alt_alt = 1;
    J_x(11,1:4) = alt_q; % column q
    J_x(11,8:10) = alt_v; % column v
    J_x(11, 11) = alt_alt; % column alt


    %% coefficient row (Cl, 12)
    % Cl_v = zeros(1,3); % use zeros for now, testflight not supersonic
    % Cl_alt = 0; % zero is an okay approximation
    Cl_cl = 1 - T * 1/param.tau_cl_alpha;
    % J_x(12, 8:10) = Cl_v; % column v
    % J_x(12,11) = Cl_alt; % column alt
    J_x(12,12) = Cl_cl; % column Cl


    %% canard angle row (delta, 13)
    delta_delta = 1 - T * 1/param.tau; % column delta % replace *1/tau with *alpha
    J_x(13,13) = delta_delta; % column delta

end
