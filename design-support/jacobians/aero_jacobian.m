% syms vx vy vz rho real
% v = [vx; vy; vz];
% 
% p = dynp(v,rho);
% inc = aoa(v);
% inc_approx = aoa_approx(v);
% 
% force_v = simplify(jacobian(p*inc,v));
% force_v_approx = simplify(jacobian(p*inc_approx,v));
% 
% f_v = simplify(jacobian(force(v,rho),v))

rho = 1.2;
vx = 100;
vz = -100:1:100;
vy = 10;

for i=1:length(vz)
    v = [vx; vy; vz(i)];
    f_exact = dynp(v,rho) * aoa(v);
    f_ex(i) = f_exact(1);
    f_quad = force_quadratic(v, rho);
    f_qu(i) = f_quad(1);
    f_sens = aoa_p_jac(v, rho);
    f_s(i) = f_sens(1);
    f_dyn = aerodynamics(v, rho);
    f_d(i) = f_dyn(1);
end


plot(vz, f_ex)
hold on
plot(vz, f_qu)
plot(vz, f_s)
plot(vz, f_d)
hold off
legend("exact", "quadratic approx", "jacobian approx", "dynamics model")


function [pressure] = dynp(v,rho)
    pressure = 0.5*rho*v'*v;
end

function [f] = force_quadratic(v,rho)
    f(1,:) = 0.5 * rho * (v(1)^2+v(3)^2) * v(3)/v(1);
    f(2,:) = - 0.5 * rho * (v(1)^2+v(2)^2) * v(2)/v(1);
end

function [force] = aoa_p_jac(v, rho)
    J = 0.5*rho*[v(3), 0, v(1);
                 - v(2), - v(1), 0];
    % v = [0; v(2); v(3)]; % only one variation
    v = [v(1); 0; 0]; % only one variation
    force = J*v;
end

function [incidence] = aoa_approx(v)
    alpha = v(3) / v(1);
    sin_alpha = alpha;
    beta = - v(2) / v(1);
    sin_beta = beta;

    incidence = [sin_alpha; sin_beta];
end

function [incidence] = aoa(v)
    alpha = atan2(v(3), v(1));
    sin_alpha = sin(alpha);
    beta = - atan2(v(2), v(1));
    sin_beta = sin(beta);

    incidence = [sin_alpha; sin_beta];
end

function [torque] = aerodynamics(v, rho)
    p_dyn = rho / 2 * norm(v)^2;

    % if v(1) >= 0.5
    %     sin_alpha = v(3)/v(1);
    %     sin_beta =  - v(2)/v(1);
    % else
    %     sin_alpha = pi/2; 
    %     sin_beta = -pi/2;
    % end
    if abs(v(1)) >= 0.5
        sin_alpha = v(3)/v(1) / sqrt( v(3)^2/v(1)^2 + 1 );
        sin_beta = - v(2)/v(1) / sqrt( v(2)^2/v(1)^2 + 1 );
    else
        sin_alpha = sign(v(3)); 
        sin_beta = sign(v(2));
    end

    torque = p_dyn * [sin_alpha; sin_beta]; 
end