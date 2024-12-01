function [x_dot] = model_f(t, x, u) % time t is not used yet, but required by matlab ode syntax
    % Computes state derivative with predictive model. Use ODE solver to compute next state.

    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose input vector: [delta_u(1), A(3)]
    delta_u = u(1); A = u(2:4);

    % get parameters
    model_params

    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = model_quaternion_rotmatrix(q);

    % calculate air data
    [~, ~, rho, ~] = model_airdata(alt);
    airspeed = norm(v);
    % Ma = airspeed / mach_local; % remove if not needed
    % alpha = atan2(v(2), v(1));
    % beta = atan2(v(3), v(1)); atan2 cannot handle complex numbers needed
    % for jacobian function. Can use atan2 is jacobian is determined otherwise
    if v(1) ~= 0 
        alpha = v(2) / v(1); % use small angle approx instead of atan2
        beta = v(3) / v(1);
    else
        alpha = 0; beta =0;
    end
    p_dyn = rho/2*airspeed^2;

    % forces (specific)
    force_aero = zeros(3,1);
    force = force_aero / m;  

    % torques
    torque_canards = Cl * c_canard * p_dyn * delta;
    torque_aero = c_aero * p_dyn;
    torque = torque_aero*[0; alpha; beta] + torque_canards*[1;0;0];

    %%%%%%%%%%%%%%%%%%%%%%%%%%% derivatives

    % quaternion derivatives
    q_dot = model_quaternion_deriv(q, w);

    % rate derivatives
    w_dot = inv(J)*(torque - cross(w, J*w));
    
    % velocity derivatives 
    %%% acceleration specific force
    a = S_SA'*A - cross(w_dot, length_cs) - cross(w, cross(w, length_cs));
    %%% use aerodynamic for simulation, acceleration for filter
    % v_dot = force - cross(w,v) + S'*g;
    v_dot = a - cross(w,v) + S'*g;

    % altitude derivative
    pos_dot = S*v;
    alt_dot = pos_dot(1);

    % canard coefficients derivative , airfoil theory
    % This turned out to be way to involved, setting the prediction to zero change for now
    Cl_dot = -1/tau_cl_alpha * (Cl - Cl_alpha); % returns Cl to expected value slowly, to force convergence in EKF
    
    % actuator dynamics
    delta_dot = -1/tau * delta + 1/tau * delta_u; % linear 1st order
    
    % concoct state derivative vector
    x_dot = [q_dot; w_dot; v_dot; alt_dot; Cl_dot; delta_dot];
end