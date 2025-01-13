function [x_dot] = model_f(t, x, u) % time t is not used yet, but required by matlab ode syntax
    % Computes state derivative with predictive model. Use ODE solver to compute next state.
    
    %% decomp, params, rotmatrix
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose input vector: [delta_u(1), A(3)]
    delta_u = u(1); A = u(2:4);

    % get parameters
    k = load("design/model/model_params.mat");

    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = model_quaternion_rotmatrix(q);

    %% air data
    [~, ~, rho, ~] = model_airdata(alt);
    airspeed = norm(v);
    p_dyn = rho/2*airspeed^2;
    %%% angle of attack / sideslip
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
    
    %% forces and moments

    % forces (specific)
    %%% comment out if using accelerometer, not needed then
    force_aero = zeros(3,1);
    force = force_aero / k.m;  

    % torques
    torque_canards = Cl * k.c_canard * p_dyn * delta;
    torque_aero = k.c_aero * p_dyn;
    torque = torque_aero*[0; alpha; beta] + torque_canards*[1;0;0];

    %% derivatives

    % quaternion derivatives
    q_dot = model_quaternion_deriv(q, w);

    % rate derivatives
    w_dot = inv(k.J)*(torque - cross(w, k.J*w));
    
    % velocity derivatives 
    %%% acceleration specific force
    a = k.S_A'*A - cross(w_dot, k.length_cs) - cross(w, cross(w, k.length_cs));
    %%% use aerodynamic for simulation, acceleration for filter
    % v_dot = force - cross(w,v) + S'*g;
    v_dot = a - 2*cross(w,v) + S'*k.g;

    % altitude derivative
    pos_dot = S*v;
    alt_dot = pos_dot(1);

    % canard coefficients derivative
    %%% returns Cl to expected value slowly, to force convergence in EKF
    Cl_dot = -1/k.tau_cl_alpha * (Cl - k.Cl_alpha); 
    
    % actuator dynamics
    %%% linear 1st order
    delta_dot = -1/k.tau * (delta - delta_u);
    
    %% concoct state derivative vector
    x_dot = [q_dot; w_dot; v_dot; alt_dot; Cl_dot; delta_dot];
end
