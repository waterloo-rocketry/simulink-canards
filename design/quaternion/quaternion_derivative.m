function [q_dot, W] = quaternion_derivative(q_un, omega)
    % computes quaternion derivative from quaternion and body rates

    % norm quaternions
    q = 1/norm(q_un) * q_un;

    % quaternion derivative
    q_dot = 0.5 * quaternion_multiply(q, [0; omega]) + norm(omega)*(q-q_un);
end