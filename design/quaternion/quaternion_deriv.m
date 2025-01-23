function [q_dot, W] = quaternion_deriv(q_un, w)
    % computes quaternion derivative from quaternion and body rates

    % norm quaternions
    q = 1/norm(q_un) * q_un;

    % angular rate matrix
    w_tilde = [0, -w(3), w(2);
               w(3), 0, -w(1);
              -w(2), w(1), 0];
    W = [0, -w';
         w, -w_tilde] / 2;

    % quaternion derivative
    q_dot = (W * q) + norm(w)*(q-q_un);
end