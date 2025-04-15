function [q_prod] = quaternion_multiply(q, r)
    % quaternion multiplication
    
    % Quaternion product matrix
    Q = [q(1), -q(2), -q(3), -q(4);
         q(2), q(1), -q(4), q(3);
         q(3), q(4), q(1), -q(2);
         q(4), -q(3), q(2), q(1)];

    %%% product
    q_prod = Q*r;
end