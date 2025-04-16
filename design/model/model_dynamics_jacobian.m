function [J_x] = model_dynamics_jacobian(dt, x, u)
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

    %% airdata 
    airdata = model_airdata(alt);
    
    %% create empty Jacobian 
    J_x = zeros(length(x), length(x));
    % could also initialize as identity eye(length(x)), as right now all
    % sub-Jacobians have identity on the main diagonal
    
    %% quaternion attitude rows (q, 1:4)
    [q_q, q_w] = quaternion_update_jacobian(q, w, dt);
    % [qdot_q, qdot_w] = quaternion_derivative_jacobian(q,w);
    % q_q = eye(4) + dt * qdot_q;
    % q_w = dt * qdot_w;

    J_x(1:4,1:4) = q_q; % column q (attitude)
    J_x(1:4, 5:7) = q_w; % column w (rates)

    %% angular rate rows (w, 5:7)
    % when implementing in C: the torque partial derivatives can probably
    % be put in one function
    [torque_v, torque_cl, torque_delta] = aerodynamics_jacobian(v, airdata, Cl, delta, param);

    w_w = eye(3) + dt * param.Jinv * (- param.J*tilde(w)); % torque_w = 0 for now
    w_v = dt * param.Jinv * torque_v;
    w_cl = dt * param.Jinv * torque_cl;
    w_delta = dt * param.Jinv * torque_delta;

    J_x(5:7,5:7) = w_w; % column w
    J_x(5:7,8:10) = w_v; % column v
    J_x(5:7,12) = w_cl; % column Cl
    J_x(5:7,13) = w_delta; % column delta


    %% velocity rows (v, 8:10)
    % v_q = dt * quaternion_rotate_jacobian(quaternion_inv(q), param.g);
    v_q = dt * quaternion_rotate_jacobian(q, param.g);
    v_w = - dt * tilde(v);
    v_v = eye(3) + dt * tilde(w);

    J_x(8:10,1:4) = v_q; % column q
    J_x(8:10,5:7) = v_w; % column w
    J_x(8:10,8:10) = v_v; % column v


    %% altitude row (alt, 11)
    % r_q = dt * quaternion_rotate_jacobian(q, v);
    r_q = dt * quaternion_rotate_jacobian(quaternion_inv(q), v);
    alt_q = r_q(1,:); % only use altitude from position vector
    r_v = dt * quaternion_rotmatrix(quaternion_inv(q));
    alt_v = r_v(1,:);
    % r_r = eye(3);
    alt_alt = 1;

    J_x(11,1:4) = alt_q; % column q
    J_x(11,8:10) = alt_v; % column v
    J_x(11, 11) = alt_alt; % column alt


    %% coefficient row (Cl, 12)
    % Cl_vx = dt * 1/param.tau_cl_alpha * airfoil_v(v(1), airdata.mach, param); 
    Cl_cl = 1 - dt * 1/param.tau_cl_alpha;
    % Cl_alt = 0; % zero is an okay approximation

    % J_x(12,11) = Cl_alt; % column alt
    % J_x(12, 8) = Cl_vx; % column v (only vx)
    J_x(12,12) = Cl_cl; % column Cl


    %% canard angle row (delta, 13)
    delta_delta = 1 - dt * 1/param.tau; % column delta % replace *1/tau with *alpha
    J_x(13,13) = delta_delta; % column delta

end

%% skew symmetric matrix / cross-product jacobian
function [skewed] = tilde(vector)
    skewed = [0, -vector(3), vector(2);
              vector(3), 0, -vector(1);
              -vector(2), vector(1), 0];
end

%% aerodynamics
function [torque_v, torque_cl, torque_delta] = aerodynamics_jacobian(v, airdata, Cl, delta, param)
    torque_vx = Cl * delta * param.c_canard * [v(1), v(2), v(3); 
                                                0, 0, 0; 
                                                0, 0, 0];
    torque_vyz = 0.5 * param.c_aero * param.Cn_alpha * [0, 0, 0;
                                                        v(3), 0, v(1);
                                                        -v(2), -v(1), 0];
    torque_v =  airdata.density * (torque_vx + torque_vyz);

    dyn_pressure = 0.5 * airdata.density * norm(v)^2;

    torque_cl = delta * param.c_canard * dyn_pressure *[1;0;0];
    torque_delta = Cl * param.c_canard * dyn_pressure *[1;0;0];
end


function [Cl_v] = airfoil_v(airspeed, sonic_speed, param)
    mach_num = airspeed / sonic_speed;

    if mach_num <= 1
        Cl_v = param.Cl_alpha;
    else
        Cl_v = param.canard_slope_linear / sonic_speed;
    end
end