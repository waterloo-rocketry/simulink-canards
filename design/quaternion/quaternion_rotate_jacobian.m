function [J_q] = quaternion_rotate_jacobian(q, vector)
    % computes rotation matrix from quaternion
    
    %%% norm quaternions
    q = 1/norm(q) * q;

    %%% quaternion definition
    qw = q(1); qv = q(2:4);    
    
    vector_tilde = [0, -vector(3), vector(2);
                    vector(3), 0, -vector(1);
                   -vector(2), vector(1), 0];
    
    %%% rotation matrix
    % S = (qw^2-qv'*qv)*eye(3) + 2*qv*qv' - 2*qw*q_tilde; % Stevens

    %%% Jacobian of rotation wrt quaternion
    J_q = 2 * [qw*vector - cross(qv, vector), qv'*vector*eye(3) + qv*vector' - vector*qv' + qw*vector_tilde]; % Sola
    
    %%% for hardcoding:
    % [2*qw*vx - 2*qy*vz + 2*qz*vy, 2*qx*vx + 2*qy*vy + 2*qz*vz, 2*qx*vy - 2*qw*vz - 2*qy*vx, 2*qw*vy + 2*qx*vz - 2*qz*vx]
    % [2*qw*vy + 2*qx*vz - 2*qz*vx, 2*qw*vz - 2*qx*vy + 2*qy*vx, 2*qx*vx + 2*qy*vy + 2*qz*vz, 2*qy*vz - 2*qw*vx - 2*qz*vy]
    % [2*qw*vz - 2*qx*vy + 2*qy*vx, 2*qz*vx - 2*qx*vz - 2*qw*vy, 2*qw*vx - 2*qy*vz + 2*qz*vy, 2*qx*vx + 2*qy*vy + 2*qz*vz]
end