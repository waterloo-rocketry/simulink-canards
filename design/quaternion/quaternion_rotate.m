function [body, inert] = quaternion_rotate(q, u)
    % rotates vector u with quaternion q
    % body is vector transform: inertial -> body frame
    % inert is vector transform: body -> inertial frame

    %%% norm quaternions
    q = 1/norm(q) * q;

    %%% quaternion definition
    q0 = q(1); qv = q(2:4);

    %%% inverse quaternion 
    % q_in = [q0; -qv];
  
    %%% to body frame
    body = 2*qv*(qv'*u) + (q0^2-qv'*qv)*u - 2*q0*(cross(qv,u)); 

    %%% to inertial frame
    inert = 2*qv*(qv'*u) + (q0^2-qv'*qv)*u - 2*q0*(cross(-qv,u)); 
end