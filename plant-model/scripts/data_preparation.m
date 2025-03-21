%% Data preparation for simulation

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

CNa_input_aoa = deg2rad(or_override_aoa_cna.Var1); % angle of attack
CNa_data_aoa = or_override_aoa_cna.Var2; % CN_alpha

CNa_input_mach = or_override_mach_cna.Var1; % Mach number
CNa_data_mach = or_override_mach_cna.Var2; % CN_alpha


%% Aero
% Nose
% CNa_nosecone = 2 * pi * (r0^2) / Ar;
x_pos_nosecone = -(logiva - logiva/2); % Nosecone center of pressure

% Body
% CNa_body = 2 * 1.1 * lTubo * Lr / Ar; %derivative of eq. 3.26 wrt alpha (making the substitution sin^2(a) = a^2)
x_pos_bodytube = 0 - logiva - lTubo/2; % Fuselage center of pressure

% Fins
[x_pos_fins, Cnfdelta, CndNi, CNa_fins, AR, Af, gamac, yparcial, Y, Lf] = fins(Cr, Ct, span, sweep, pos_aletas, rt, N_fins, Ar, Lr, r0);

% Tail
% CNa_tail= -2 * (1 - ((r2 / rt)^2));
r=rt/r2;
x_pos_tail = pos_tail - (h/3) * (1 + ( (1 - r) / (1 - r^2) ) );

% Canards
[x_pos_canard,Cnalfat_canard,Cnfdelta_canard, CndNi_canard, AR_canard, Af_canard, gamac_canard, yparcial_canard, Y_canard, Lf_canard] = canards(Cr,Ct, span, Cr_canard, Ct_canard, span_canard, pos_canard, N_canard, Ar, Lr, r0);