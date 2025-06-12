function [pos_x_cp_subsonic, pos_r_chord_mean, area_planform, midchord_angle, fin_factor, pos_x_cp_mach2] = aerosurface(chord_root, chord_tip, height, sweep_angle, pos_x, number, rocket_diameter)
    % calculates coefficients and other parameters for aerosurfaces, such
    % as fins or canards. The aerosurface must be trapezoidal (for triangle: short tip chord)

    % variables
    mach = 2; % calculate supersonic parameters for Ma = 2. This hould be done online in the future
    beta = min(sqrt(mach^2-1), 0.3);

    % preliminaries
    area_planform = height * (chord_root + chord_tip) / 2;
    aspect_ratio = 2*height^2 / area_planform;
    pos_x_tip = height * tan(sweep_angle); % x postion of fin tip at leading edge, from tip of root
    midchord_angle = atan2( pos_x_tip + 0.5*chord_tip - 0.5*chord_root, height ); % mid chord angle

    % center of pressure axial
    chord_aerodynamic_mean = 2/3 * (chord_root + chord_tip - (chord_root*chord_tip)/(chord_root+chord_tip));
    pos_x_cp_subsonic = pos_x + pos_x_tip/3 * (chord_root+2*chord_tip)/(chord_root+chord_tip) + ...
                        1/6 * (chord_root^2+chord_tip^2+chord_root*chord_tip) / (chord_root+chord_tip);
    pos_x_cp_mach2 = pos_x + chord_aerodynamic_mean * (aspect_ratio*beta - 0.67) / (2*aspect_ratio*beta-1);
    % todo online: interpolation for variable Mach numbers

    % center of pressure radial
    height_aerodynamic_mean = height / 3 * (chord_root + 2*chord_tip) / (chord_root + chord_tip); %mean aerodynamic chord distance, radially from root
    pos_r_chord_mean = rocket_diameter + (fin_height/3) * height_aerodynamic_mean; %mean aerodynamic chord distance with the radius added

    % body interference factor
    K_body = 1 + rocket_diameter / (height + rocket_diameter); 
    fin_factor = K_body;
    
    % number of fins to factor
    if fin_number == 1 || fin_number == 2
        % fin_factor = fin_factor;
    elseif fin_number == 3 
        fin_factor = 1.5 * fin_factor;
    elseif fin_number == 4 
        fin_factor = 2 * fin_factor;
    end

end