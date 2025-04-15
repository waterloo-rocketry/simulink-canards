function [Cl_theory] = airfoil_jacobian(airspeed, sonic_speed, sweep)
    mach_num = airspeed / sonic_speed;

    % if mach_num <= 1
        % cone = 0;
    % else
        cone = acos(1 / mach_num);
    % end
    % if cone > sweep
        % Cl_theory = 4 / sqrt(mach_num^2 - 1);
    % else
        m = cot(sweep)/cot(cone);
        a = m*(0.38+2.26*m-0.86*m^2);
        Cl_theory = 2*pi^2*cot(sweep) / (pi + a);
    % end
end