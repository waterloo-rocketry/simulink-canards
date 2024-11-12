function [x_dot] = model_f(t, x, u) % time t is not used yet, but required by matlab ode syntax
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose input vector: [delta_u(1), A(3)]
    delta_u = u(1); A = u(2:4);

    % get parameters
    model_params

    % compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
    S = quaternion_rotmatrix(q);
    
    % calculate air data
    [~, ~, rho, mach_local] = model_airdata(alt, g, air_gamma, air_R, air_atmosphere);
    airspeed = norm(v);
    p_dyn = rho/2*airspeed^2;
    Ma = airspeed / mach_local; % remove if not needed

    % forces (specific)
    force_aero = zeros(3,1);
    force = force_aero / m + inv(S)*g;  

    % torques
    torque_canards = delta;
    torque_aero = zeros(3,1);
    torque = torque_aero + torque_canards*[1;0;0];

    %%%%%%%%%%%%%%%%%%%%%%%%%%% derivatives

    % quaternion derivatives
    q_dot = quaternion_deriv(q, w);

    % rate derivatives
    w_dot = inv(J)*(torque - cross(w, J*w));
    
    %%% acceleration specific force
    a = S_S*A - cross(w_dot, length_cs) - cross(w, cross(w, length_cs));

    % velocity derivatives 
    %%% use aerodynamic for simulation, acceleration for filter
    v_dot = force - cross(w,v);
    v_dot = a - cross(w,v) + inv(S)*g;

    % altitude derivative
    pos_dot = S*v;
    alt_dot = pos_dot(1);

    % canard coefficients derivative , airfoil theory
    % This turned out to be way to involved, setting the prediction to zero change for now
    % could use numerical differentation in the future
    Cl_dot = 0; % derivation of CL_alpha_c with Ma = Ma(t). 
    
    % actuator dynamics
    delta_dot = -1/tau * delta + 1/tau * delta_u;
    
    % concoct state derivative vector
    x_dot = [q_dot; w_dot; v_dot; alt_dot; Cl_dot; delta_dot];
end


function [q_dot] = quaternion_deriv(q_un, w)
    % computes quaternion derivative from quaternion and body rates

    % norm quaternions
    q = 1/norm(q_un) * q_un;

    % angular rate matrix
    w_tilde = [0, -w(3), w(2);
               w(3), 0, -w(1);
              -w(2), w(1), 0];
    W = [0, -w';
         w, -w_tilde];

    % quaternion derivative
    q_dot = (0.5* W * q) + norm(w)*(q-q_un);
end


function [S] = quaternion_rotmatrix(q)
    % computes rotation matrix from quaternion

    % norm quaternions
    q = 1/norm(q) * q;

    q_tilde = [0, -q(3+1), q(2+1);
               q(3+1), 0, -q(1+1);
              -q(2+1), q(1+1), 0];
    S = eye(3) + 2*q(0+1)*q_tilde + 2*q_tilde*q_tilde;
end