function [q_prod] = quaternion_multiply(q, r)
    % quaternion multiplication
    
    %%% norm quaternions
    q = 1/norm(q) * q;

   % Quaternion product matrix
    Q = [q(1), -q(2), -q(3), -q(4);
         q(2), q(1), -q(4), q(3);
         q(3), q(4), q(1), -q(2);
         q(4), -q(3), q(2), q(1)];

    %%% product
    q_prod = Q*r;
end