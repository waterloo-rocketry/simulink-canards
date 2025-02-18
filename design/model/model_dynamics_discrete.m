function [x_new] = model_dynamics_discrete(T, x, u)
    % Computes state derivative with predictive model. Use ODE solver to compute next state.
    
    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose input vector: [delta_u(1), A(3)]
    delta_u = u(1); a = u(2:4);

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
    if abs(v(1)) >= 0.5
        sin_alpha = v(3)/v(1) / sqrt( v(3)^2/v(1)^2 + 1);
        sin_beta = v(2)/v(1) / sqrt( v(2)^2/v(1)^2 + 1);
    else
        sin_alpha = sign(v(3)); 
        sin_beta = sign(v(2));
    end

    %%% torques
    torque_canards = Cl *  delta * param.c_canard * p_dyn *[1;0;0];
    torque_aero = p_dyn * ( param.Cn_alpha*[0; sin_alpha; -sin_beta] + param.Cn_omega*[0; w(2); w(3)] ) * param.c_aero;
    torque = torque_canards + torque_aero;
    torque = [0;0;0];

    %% time updates

    % quaternion update
    % q_new = quaternion_increment(q, w, T);
    q_new = q + T * quaternion_derivative(q, w);
    q_new = q_new / norm(q_new);

    % rate update
    w_new = w + T * inv(param.J) * (torque - cross(w, param.J*w));
    
    % velocity update 
    %%% acceleration specific force    
    v_new = v + T * (a - cross(w,v) + S*param.g);

    % altitude update
    v_earth = (S')*v;
    alt_new = alt + T * v_earth(1);

    % canard coefficients derivative
    %%% returns Cl to expected value slowly, to force convergence in EKF
    Cl_new = Cl + T * (-1/param.tau_cl_alpha * (Cl - param.Cl_alpha)); 
    
    % actuator dynamics
    %%% linear 1st order
    delta_new = delta + T * (-1/param.tau * (delta - delta_u));
    
    %% concoct state derivative vector
    x_new = [q_new; w_new; v_new; alt_new; Cl_new; delta_new];
end
