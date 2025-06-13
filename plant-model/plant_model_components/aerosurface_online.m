function [C_normal_alpha_1] = aerosurface_online(mach, incidence, aspect_ratio, midchord_angle)
    
    % should aerosurface.m be pasted here? 
    % how to do handling of the dozens of constant parameters?

    gamma = 1.4; % adiabatic exponent of air

    % threshold values
    subsonic = 0.85;
    supersonic = 1.6;

    % prandtl factor
    % beta = max(sqrt(abs(1-mach^2)), 0.4);
    beta = sqrt(abs(1-mach^2));

    if mach <= subsonic % subsonic
        C_normal_alpha_1 = (2 * pi * aspect_ratio ) / ...
                           (2 + sqrt( 4 + ( beta * aspect_ratio / cos(midchord_angle) )^2 ) );

    elseif mach > supersonic % supersonic
        K_n = [((gamma+1)*mach^8+(2*gamma^2-7*gamma-5)*mach^6+10*(gamma+1)*mach^4+8)/(6*beta^7); 
             ((gamma+1)*mach^4-4*beta^2)/(4*beta^4);  
              2/beta];
        C_normal_alpha_1 = polyval(K_n, incidence);

    else % transonic
        subsonic_beta = sqrt(1 - subsonic^2);
        subsonic_temp1 = sqrt( 4 + ( subsonic_beta * aspect_ratio / cos(midchord_angle) )^2 );
        subsonic_value = (2 * pi * aspect_ratio ) / (2 + subsonic_temp1 );
        subsonic_deriv = (2 * pi * aspect_ratio) * mach / ( (aspect_ratio * cos(midchord_angle))^2 * subsonic_temp1 * (1 + subsonic_temp1)^2 );
        subsonic_deriv = (2*aspect_ratio^3*mach*pi)/(cos(midchord_angle)^2*((4 - (aspect_ratio^2*(subsonic^2 - 1))/cos(midchord_angle)^2)^(1/2) + 2)^2*(4 - (aspect_ratio^2*(subsonic^2 - 1))/cos(midchord_angle)^2)^(1/2));
        
        
        supersonic_beta = sqrt(supersonic^2 - 1);
        supersonic_K_n = [((gamma+1)*supersonic^8+(2*gamma^2-7*gamma-5)*supersonic^6+10*(gamma+1)*supersonic^4+8)/(6*supersonic_beta^7); 
                          ((gamma+1)*supersonic^4-4*supersonic_beta^2)/(4*supersonic_beta^4);  
                            2/supersonic_beta];
        supersonic_value = polyval(supersonic_K_n, incidence);
        supersonic_deriv = - 2 * supersonic / supersonic_beta^3;
    
        mach_delta = supersonic - subsonic;
        t = (mach - subsonic) / mach_delta;
        t = min(max(t, 0), 1);
    
        % Hermite-style cubic interpolation with endpoint values and slopes
        h00 = 2*t^3 - 3*t^2 + 1;
        h10 = t^3 - 2*t^2 + t;
        h01 = -2*t^3 + 3*t^2;
        h11 = t^3 - t^2;
    
        C_normal_alpha_1 = h00 * subsonic_value + h10 * mach_delta * subsonic_deriv + ...
                           h01 * supersonic_value + h11 * mach_delta * supersonic_deriv;

    end 
end