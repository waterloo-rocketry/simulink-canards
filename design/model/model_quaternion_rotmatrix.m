function [S] = model_quaternion_rotmatrix(q)
    % computes rotation matrix from quaternion
    
    %%% quaternion definition
    q0 = q(1); qv = q(2:4);

    %%% norm quaternions
    q = 1/norm(q) * q;
    
    %%% skew symetric quaternion matrix
    q_tilde = [0, -q(4), q(3);
               q(4), 0, -q(2);
              -q(3), q(2), 0];
    
    %%% rotation matrix
    % S = (eye(3) + 2*q0*q_tilde + 2*q_tilde*q_tilde)'; Schiehlen
    S = 2*qv*qv' + (q0^2-qv'*qv)*eye(3)-2*q0*q_tilde; % Stevens
end