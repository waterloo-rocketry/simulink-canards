function [C_normal_alpha_1] = aerosurface_online(mach)
     % prandtl factor
    beta = max(sqrt(abs(1-M^2)), 0.5);
    
    % should aerosurface.m be pasted here? 
    % how to do handling of the dozens of constant parameters?

    C_normal_alpha_1 = (2 * pi * height^2 / rocket_area_frontal) / (1 + sqrt( 1 + ( beta * aspect_ratio/2 / cos(midchord_angle) )^2 ) );

end