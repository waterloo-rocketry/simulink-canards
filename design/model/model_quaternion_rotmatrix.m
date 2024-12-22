function [S] = model_quaternion_rotmatrix(q)
    % computes rotation matrix from quaternion

    % norm quaternions
    q = 1/norm(q) * q;
    
    % skew symetric quaternion matrix
    q_tilde = [0, -q(4), q(3);
               q(4), 0, -q(2);
              -q(3), q(2), 0];
    
    % rotation matrix
    S = eye(3) + 2*q(0+1)*q_tilde + 2*q_tilde*q_tilde;
end