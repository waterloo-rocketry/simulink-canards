function [C_normal_1, C_m_1, cp] = aerobody_online(mach, alpha, area_bow, area_aft, area_planform, length, volume, x_cp)

    %%% Normal force coefficient 
    gamma = 1.4; % adiabatic exponent of air

    % threshold values
    subsonic = 0.85;
    supersonic = 1.6;

    % prandtl factor
    % beta = max(sqrt(abs(1-mach^2)), 0.4);
    beta = sqrt(abs(1-mach^2));

    C_normal_1 = 2 * (area_aft - area_bow) * sin(alpha) + 1.1 * area_planform * sin(alpha)^2;
    
    % Unused pitch moment correction
    C_m_1 = 2 * (length * area_aft - volume) * sin(alpha);

    cp = x_cp;

end
