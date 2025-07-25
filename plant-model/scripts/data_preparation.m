%% Data preparation for simulation
or_data = fillmissing(or_data, 'previous');

%% MCI
% Wet
I_xx_0 = or_data.RotationalMomentOfInertia_kg_m__(1);
I_yy_0 = or_data.LongitudinalMomentOfInertia_kg_m__(1);
I_zz_0 = I_yy_0; % rocket is axially symmetric
I_0 = [I_xx_0 0 0; 0 I_yy_0 0; 0 0 I_zz_0]; %kg*m^2
total_mass_0 = or_data.Mass_g_(1) / 1000; %g -> kg

% Dry
I_xx_d = or_data.RotationalMomentOfInertia_kg_m__(find(~isnan(or_data.RotationalMomentOfInertia_kg_m__), 1, 'last')); %moments of inertia become NaN at the end for some reason?
I_yy_d = or_data.LongitudinalMomentOfInertia_kg_m__(find(~isnan(or_data.LongitudinalMomentOfInertia_kg_m__), 1, 'last'));
I_zz_d = I_yy_d; % rocket is axially symmetric
I_d = [I_xx_d 0 0; 0 I_yy_d 0; 0 0 I_zz_d]; %kg*m^2
total_mass_d = or_data.Mass_g_(find(~isnan(or_data.Mass_g_), 1, 'last')) / 1000; % g -> kg

%% Input Time Series
sim_time = or_data.x_Time_s_; % s
F_thrust = or_data.Thrust_N_; % N assume thrust is perfectly aligned
F_thrust = circshift(F_thrust, 5);
F_thrust(end-5:end) = 0;
F_thrust(2:5) = NaN;
F_thrust = fillmissing(F_thrust, 'linear');

OR_cg = -or_data.CGLocation_cm_ / 100; % centre of gravity over time (replace NaN with Last val)
% Do diff here since simulink may become unstable
mass = or_data.Mass_g_ / 1000; % g -> kg
Mdot = diff(mass) ./ diff(sim_time); % kg/s 1st discrete derivative
Mdot(end+1) = Mdot(end);
% Unfiltered quality is shit - need to see how simlink block behaves
Mdot = lowpass(Mdot, 0.1);

Cd = or_data.DragCoefficient___;
Mach = or_data.MachNumber___;

%% Reference Time Series
alt = or_data.Altitude_m_;
vel_ver = or_data.VerticalVelocity_m_s_;
drag = or_data.DragForce_N_;
crossrange = or_data.LateralDistance_m_;
v_crossrange = or_data.LateralVelocity_m_s_;
angle_vert_deg = 90 - or_data.VerticalOrientation_zenith____;

%% Cd vs Mach table
% Combine the two vectors into a 2-column matrix
data = [Mach(:), Cd(:)];  % Create a 2-column matrix (Mach, Cd)

% Sort the rows by the Mach number (first column)
sorted_data = sortrows(data, 1);  % Sort by Mach number (first column)

% Remove rows with duplicate Mach values (keep the first occurrence)
[~, unique_idx] = unique(sorted_data(:, 1), 'first');  % Find unique Mach numbers
unique_data = sorted_data(unique_idx, :);  % Keep only rows with unique Mach numbers

% Remove rows with any NaN values
unique_data = unique_data(~any(isnan(unique_data), 2), :);  % Remove rows with NaN

% Get the Cd value corresponding to Mach 0.3
mach_03_idx = find(unique_data(:, 1) >= 0.3, 1, 'first');  % Find the index of Mach closest to or equal to 0.3
Cd_at_03 = unique_data(mach_03_idx, 2);  % Cd value at Mach 0.3

% Replace Cd values for Mach < 0.3 with Cd value at Mach 0.3
unique_data(unique_data(:, 1) < 0.3, 2) = Cd_at_03;

% Final lookup table
lookup_table = unique_data;
CD_input = lookup_table(:, 1); % Mach #
CD_data = lookup_table(:, 2); % Cd

%% Cn_alpha tables

% CNa_input_aoa = deg2rad(or_override_aoa_cna{:,1}); % angle of attack
% CNa_data_aoa = or_override_aoa_cna{:,2}; % CN_alpha
% 
% CNa_input_mach = or_override_mach_cna{:,1}; % Mach number
% CNa_data_mach = or_override_mach_cna{:,2}; % CN_alpha


%% Aero
% Nose
[nosecone_area_planform, nosecone_area_bow, nosecone_area_aft, nosecone_volume, nosecone_pos_x_cp] = aerobody(nosecone_length, 0, 2 * nosecone_radius, 0);


% Body
[body_area_planform, body_area_bow, body_area_aft, body_volume, body_pos_x_cp] = aerobody(body_length, rocket_diameter, rocket_diameter, - nosecone_length);

% Fins 
% [fin_pos_x_cp, fin_Cnfdelta, fin_CndNi, fin_CNa, fin_aspectratio, fin_area, fin_midchord_angle, fin_dist_chord_mean, fin_pos_r_chord_mean, fin_leading_edge] = fins(fin_chord_root, fin_chord_tip, fin_height, fin_sweep, fin_pos_x_roottip, fin_number, rocket_area_frontal, rocket_diameter);
[fin_pos_x_cp, fin_pos_r_mean, fin_area, fin_aspectratio, fin_midchord_angle, fin_factor, fin_pos_x_cp_mach2] = aerosurface(fin_chord_root, fin_chord_tip, fin_height, fin_sweep_angle, fin_pos_x_roottip, fin_number, rocket_diameter);


% Tail
[tail_area_planform, tail_area_bow, tail_area_aft, tail_volume, tail_pos_x_cp] = aerobody(tail_length, 2 * tail_radius_outer, 2 * tail_radius_smallest, - nosecone_length - body_length);

% Canards 
% [canard_pos_x, canard_Cnalfat, canard_Cnfdelta, canard_CndNi, canard_aspectratio, canard_area, canard_midchord_angle, canard_dist_chord_mean, canard_pos_r_mean, canard_leading_edge] = canards(canard_chord_root, canard_chord_tip, canard_height, canard_pos_x_roottip, canard_number, rocket_area_frontal, rocket_diameter);
[canard_pos_x, canard_pos_r_mean, canard_area, canard_aspectratio, canard_midchord_angle, canard_factor, canard_pos_x_cp_mach2] = aerosurface(canard_chord_root, canard_chord_tip, canard_height, canard_sweep_angle, canard_pos_x_roottip, canard_number, rocket_diameter);