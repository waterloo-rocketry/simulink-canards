function [q_new] = quaternion_increment(q, omega, dt)
    % computes new quaternion from old quaternion and body rates

    % norm quaternions
    q = q / norm(q);
    
    % incremental quaternion
    dphi = norm(omega) * dt / 2;
    dn = omega / norm(omega);

    dq = [cos(dphi); dn*sin(dphi)];
     
    % quaternion derivative
    q_new = quaternion_multiply(q, dq);
end