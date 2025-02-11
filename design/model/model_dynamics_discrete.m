function [x_dot] = model_dynamics_discrete(t, x, u, T)
    % Computes state derivative with predictive model. Use ODE solver to compute next state.
    
    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose input vector: [delta_u(1), A(3)]
    delta_u = u(1); A = u(2:end);
    
    global IMU_select

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end
    
    %% compute rotation matrix 
    %%% attitude transformation, inertial to body frame
    S = quaternion_rotmatrix(q);

    %% aerodynamics
    %%% air data
    [~, ~, rho, ~] = model_airdata(alt);
    p_dyn = rho/2*norm(v)^2;

    %%% angle of attack/sideslip
    if norm(v(1)) >= 0 
        alpha = atan(v(3)/v(1));
        beta = atan(v(2)/v(1));
    elseif norm(v(1)) <= 0
        alpha = pi - atan(v(3)/v(1));
        beta = pi - atan(v(2)/v(1));
    else
        alpha = sign(v(3))*pi/2; 
        beta = sign(v(2))*pi/2;
    end

    %%% torques
    torque_canards = Cl *  delta * param.c_canard * p_dyn *[1;0;0];
    torque_aero = p_dyn * ( param.Cn_alpha*[0; v(3); v(2)] + param.Cn_omega*[0; w(2); w(3)] ) * param.c_aero;
    torque = torque_aero + torque_canards;
    % torque = [0;0;0];

    %% derivatives

    % quaternion update
    q_new = quaternion_increment(q, w, T);

    % rate update
    w_new = w + T * inv(param.J) * (torque - cross(w, param.J*w));
    
    % velocity update 
    %%% acceleration specific force
    if isreal(v) || isreal(w)
        a = zeros(3,1);
    else
        a = zeros(3,1) + 1i*zeros(3,1);
    end
    %%% average specific force of selected sensors
    for k = 1:length(IMU_select)
        if IMU_select(k) == 1
            dk = param.d_k(:, k);
            ak = A( 3*(k-1)+1 : 3*k ) - cross(w, cross(w, dk)) - cross(w_dot, dk);
            a = a + ak/(length(A)/3);
        end
    end
    % g_body = quaternion_rotate(q, param.g);
    g_body = (S)*param.g;
    v_new = v + T * (a - cross(w,v) + g_body);

    % altitude update
    v_earth = (S')*v;
    alt_new = alt + T * v_earth(1);

    % canard coefficients derivative
    %%% returns Cl to expected value slowly, to force convergence in EKF
    Cl_dot = Cl + T * (-1/param.tau_cl_alpha * (Cl - param.Cl_alpha)); 
    
    % actuator dynamics
    %%% linear 1st order
    delta_dot = delta + T * (-1/param.tau * (delta - delta_u));
    
    %% concoct state derivative vector
    x_dot = [q_new; w_new; v_new; alt_new; Cl_new; delta_new];
end
