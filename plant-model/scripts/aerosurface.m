function [] = aerosurface(chord_root, chord_tip, height, sweep_angle, pos_x, number, rocket_diameter, rocket_area_frontal)
    % calculates coefficients and other parameters for aerosurfaces, such
    % as fins or canards. The aerosurface must be trapezoidal (for triangle: short tip chord)
    %Output names: fin_ or canard_ [pos_x_cp, CNf_delta, CNdNi, CNa,
    %aspect_ratio, area, midchord_angle, pos_r_chord_mean, leading_edge, K_body]

    % variables
    Mach = 2; % calculate supersonic parameters for Ma = 2. This hould be done online in the future
    beta = min(sqrt(Mach^2-1), 0.3);

    % preliminaries
    area_planform = height * (chord_root + chord_tip) / 2;
    aspect_ratio = 2*height^2 / area_planform;
    pos_x_tip = height * tan(sweep_angle); % x postion of fin tip at leading edge, from tip of root
    midchord_angle = atan2( pos_x_tip + 0.5*chord_tip - 0.5*chord_root, height ); % mid chord angle

    % center of pressure axial
    chord_aerodynamic_mean = 2/3 * (chord_root + chord_tip - (chord_root*chord_tip)/(chord_root+chord_tip));
    pos_x_cp_subsonic = pos_x_tip/3 * (chord_root+2*chord_tip)/(chord_root+chord_tip) + ...
                        1/6 * (chord_root^2+chord_tip^2+chord_root*chord_tip) / (chord_root+chord_tip);
    pos_x_cp_mach2 = chord_aerodynamic_mean * (aspect_ratio*beta - 0.67) / (2*aspect_ratio*beta-1);
    % todo online: interpolation for variable Mach numbers

    % center of pressure radial
    height_aerodynamic_mean = height / 3 * (chord_root + 2*chord_tip) / (chord_root + chord_tip); %mean aerodynamic chord distance, radially from root
    pos_r_chord_mean = rocket_diameter + (fin_height/3) * height_aerodynamic_mean; %mean aerodynamic chord distance with the radius added

    % coefficients
    C_roll_precomp = number * pos_r_chord_mean / rocket_diameter;

    K_body = 1 + rocket_diameter / (height + rocket_diameter); %interference factor

end