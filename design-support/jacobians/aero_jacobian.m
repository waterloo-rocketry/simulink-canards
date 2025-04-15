syms vx vy vz rho real
v = [vx; vy; vz];

p = dynp(v,rho);
inc = aoa(v);
inc_approx = aoa_approx(v);

force_v = simplify(jacobian(p*inc,v));
force_v_approx = simplify(jacobian(p*inc_approx,v))

f_v = simplify(jacobian(force(v,rho),v))

function [pressure] = dynp(v,rho)
    pressure = 0.5*v'*v;
end

function [f] = force(v,rho)
    f(1,:) = 0.5 * (v(1)^2+v(3)^2) * v(3)/v(1);
    f(2,:) = 0.5 * (v(1)^2+v(2)^2) * v(2)/v(1);
end

function [incidence] = aoa_approx(v)
    alpha = v(3) / v(1);
    sin_alpha = alpha;
    beta = v(2) / v(1);
    sin_beta = beta;

    incidence = [sin_alpha; sin_beta];
end

function [incidence] = aoa(v)
    alpha = atan2(v(3), v(1));
    sin_alpha = sin(alpha);
    beta = atan2(v(2), v(1));
    sin_beta = sin(beta);

    incidence = [sin_alpha; sin_beta];
end