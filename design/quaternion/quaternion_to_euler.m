function [euler] = quaternion_to_euler(q)
    % computes euler angles (yaw-pitch-roll seqeunce) from quaternion
    
    %%% norm quaternions
    q = 1/norm(q) * q;

    %%% quaternion definition
    qw = q(1); qx = q(2); qy = q(3); qz = q(4);

    %%% Euler angles, after Zipfel
    yaw = atan2( 2*(qx*qy + qw*qz), (qw^2+qx^2-qy^2-qz^2) );
    pitch = asin( -2*(qx*qz - qw*qy) );
    roll = atan2( 2*(qy*qz + qw*qx), (qw^2-qx^2-qy^2+qz^2) );

    euler = [roll; pitch; yaw];
end