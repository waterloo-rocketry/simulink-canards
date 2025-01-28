function [q_prod] = quaternion_mult(q1, q2)
    % quaternion multiplication
    
    %%% norm quaternions
    % q = 1/norm(q) * q;

    %%% quaternion definition
    q1w = q1(1); q1v = q1(2:4);
    q2w = q2(1); q2v = q2(2:4);
    
    %%% skew symetric quaternion matrix
    % q_tilde = [0, -q(4), q(3);
    %            q(4), 0, -q(2);
    %           -q(3), q(2), 0];

    %%% product
    q_prod = [q1w*q2w - q1v'*q2v; 
              q1w*q2v + q2w*q1v + cross(q1v, q2v)];
end