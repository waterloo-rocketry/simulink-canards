function [] = aerosurface(chord_root, chord_tip, height, sweep, number, rocket_diameter)
    % calculates coefficients and other parameters for aerosurfaces, such
    % as fins or canards. The aerosurface must be trapezoidal (for triangle: short tip chord)

    area_planform = height * (chord_root + chord_tip) / 2;
    chord_aerodynamic_mean = 2/3 * (chord_root + chord_tip - (chord_root*chord_tip)/(chord_root+chord_tip));
    height_aerodynamic_mean = height / 3 * (chord_root + 2*chord_tip) / (chord_root + chord_tip);
end