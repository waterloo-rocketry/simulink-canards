function [q_inv] = quaternion_inv(q)
    % inverse quaternion

    %%% quaternion definition
    q0 = q(1); qv = q(2:4);

    %%% inverse quaternion 
    q_inv = [q0; -qv];
end