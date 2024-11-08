function [x_dot] = model_f(x, u)
    % state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % rotational matrix
    S = quaternion_rotmatrix(q);

    % get parameters
    model_params

    % quaternion derivatives
    q_dot = quaternion_deriv(q, w);

    % torques
    ...

    % rate derivatives
    w_dot = inv(J)*(torque - cross(w, J*w));

    % forces
    ...
    force = inv(S)*[-G,0,0]';   

    % velocity derivatives 
    v_dot = force/m - cross(w,v); 

    % altitude
    pos_dot = S*v
    alt_dot = pos_dot(1);

    % canard coefficients, airfoil theory
    Cl_dot = 0; % derivation of CL_alpha_c with Ma = Ma(t)
    
    % actuator dynamics
    delta_dot = -1/tau * delta + 1/tau * u;

    x_dot = [q_dot; w_dot; v_dot; alt_dot; Cl_dot; delta_dot];
end


function [q_dot] = quaternion_deriv(q_un, w)
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
    q_tilde = [0, -q(3+1), q(2+1);
               q(3+1), 0, -q(1+1);
              -q(2+1), q(1+1), 0];
    S = eye(3) + 2*q(0+1)*q_tilde + 2*q_tilde*q_tilde;
end