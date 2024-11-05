function [x_dot] = model_f(x, u)
    % state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % quaternion derivatives
    q_dot = quaternion(q, w);

    % torques

    % rate derivatives
    w_dot = 

    % forces

    % velocity derivatives
    v_dot = 

    % altitude
    alt_dot = 

    % canard coefficient, airfoil theory
    Cl_dot = 
    
    % actuator dynamics
    delta_dot = -1/tau * delta + 1/tau * u;

    x_dot = [q_dot; w_dot; v_dot; alt_dot; Cl_dot; delta_dot];
end


function [q_dot] = quaternions(q, w)
    % norm quaternions
    q = 1/norm(q) * q;

    % angular rate matrix
    w_tilde = [0, -w(3), w(2);
               w(3), 0, -w(1);
              -w(2), w(1), 0];
    W = [0, -w';
         w, -w_tilde];

    % quaternion derivative
    q_dot = (0.5* W * q);
end