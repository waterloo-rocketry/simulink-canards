function [S] = model_quaternion_rotmatrix(q)
    % computes rotation matrix from quaternion

    % norm quaternions
    q = 1/norm(q) * q;
    
    % skew symetric quaternion matrix
    q_tilde = [0, -q(3+1), q(2+1);
               q(3+1), 0, -q(1+1);
              -q(2+1), q(1+1), 0];
    
    % rotation matrix
    S = eye(3) + 2*q(0+1)*q_tilde + 2*q_tilde*q_tilde;
end