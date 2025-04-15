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
    %%% hardcoding:
    % ux = 2*qx*(qx*ux + qy*uy + qz*uz) - 2*qw*(qy*uz - qz*uy) - ux*(- qw^2 + qx^2 + qy^2 + qz^2)
    % uy = 2*qy*(qx*ux + qy*uy + qz*uz) + 2*qw*(qx*uz - qz*ux) - uy*(- qw^2 + qx^2 + qy^2 + qz^2)
    % uz = 2*qz*(qx*ux + qy*uy + qz*uz) - 2*qw*(qx*uy - qy*ux) - uz*(- qw^2 + qx^2 + qy^2 + qz^2)

    %%% to inertial frame
    inert = 2*qv*(qv'*u) + (q0^2-qv'*qv)*u - 2*q0*(cross(-qv,u)); 
    %%% hardcoding:
    % ux = 2*qx*(qx*ux + qy*uy + qz*uz) + 2*qw*(qy*uz - qz*uy) - ux*(- qw^2 + qx^2 + qy^2 + qz^2)
    % uy = 2*qy*(qx*ux + qy*uy + qz*uz) - 2*qw*(qx*uz - qz*ux) - uy*(- qw^2 + qx^2 + qy^2 + qz^2)
    % uz = 2*qz*(qx*ux + qy*uy + qz*uz) + 2*qw*(qx*uy - qy*ux) - uz*(- qw^2 + qx^2 + qy^2 + qz^2)
end