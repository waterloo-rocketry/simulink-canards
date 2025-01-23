function [q_inv] = quaternion_inv(q)
    % inverse quaternion

    %%% norm quaternions
    q = 1/norm(q) * q;

    %%% quaternion definition
    q0 = q(1); qv = q(2:4);

    %%% inverse quaternion 
    q_inv = [q0; -qv];
  end