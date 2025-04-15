function [q_dot] = quaternion_derivative(q_un, omega)
    % computes quaternion derivative from quaternion and body rates

    % norm quaternions
    q = q_un / norm(q_un);
    % q = q_un;

    % quaternion derivative
    q_dot = 0.5 * quaternion_multiply(q, [0; omega]);% - norm(omega)*(q-q_un);
end