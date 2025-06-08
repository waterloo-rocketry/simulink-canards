function [C_normal_alpha, C_roll] = aerosurface_online(V_air_B, omega_B, rho, lever_arm, mach, delta, pos_r_chord_mean, C_roll_precomp, number, K_body)
     % prandtl factor
    beta = max(sqrt(abs(1-M^2)), 0.5);
    
    % relative velocity
    Vrel = V_air_B + cross(omega_B, lever_arm);
    
    u_radial = omega_B(1) * pos_r_chord_mean;
    alpha_local = atan2(u_radial, Vrel(1));
    incidence = delta - alpha_local;


    % coefficients 
    C_normal_alpha_1 = K_body * (2 * pi * height^2 / rocket_area_frontal) / (1 + sqrt( 1 + ( beta * aspect_ratio/2 / cos(midchord_angle) )^2 ) );

    if number == 1 || number == 2
        C_normal_alpha = C_normal_alpha_1;
    elseif number == 3 
        C_normal_alpha = 1.5 * C_normal_alpha_1;
    elseif number == 4 
        C_normal_alpha = 2 * C_normal_alpha_1;
    end

    C_roll = incidence * C_normal_alpha_1 * C_roll_precomp;

end