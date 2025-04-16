function [qnew_q, qnew_w] = quaternion_update_jacobian(q_un, w, dt)
    % computes quaternion derivative from quaternion and body rates

    % norm quaternions
    q = q_un / norm(q_un);
    % q = q_un;

    % Quaternion product matrix
    Q = [q(1), -q(2), -q(3), -q(4);
         q(2), q(1), -q(4), q(3);
         q(3), q(4), q(1), -q(2);
         q(4), -q(3), q(2), q(1)];

    % Big Omega matrix
    W = [0, -w(1), -w(2), -w(3);
         w(1), 0, w(3), -w(2);
         w(2), -w(3), 0, w(1);
         w(3), w(2), -w(1), 0];

    % quaternion derivative Jacobians
    qnew_q = eye(4) + 0.5 * dt * W;
    qnew_w = 0.5 * dt * Q(:, 2:4);
end