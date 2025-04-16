function [q_new] = quaternion_update(q_un, omega, dt)
    % computes quaternion update from quaternion and body rates

    % norm quaternions
    q = q_un / norm(q_un);
    
    % quaternion derivative
    q_dot = 0.5 * quaternion_multiply(q, [0; omega]);% - norm(omega)*(q-q_un);

    % update and norm
    q_new = q + dt * q_dot;
    q_new = q_new / norm(q_new);
end