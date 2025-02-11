function [q_new] = quaternion_increment(q, omega, dt)
    % computes quaternion derivative from quaternion and body rates

    % norm quaternions
    q = 1/norm(q) * q;
    
    % incremental quaternion
    dphi = norm(omega) * dt / 2;
    dn = omega / norm(omega);

    dq = [sin(dphi); dn*cos(dphi)];
     
    % quaternion derivative
    q_new = quaternion_multiply(q, dq);
end