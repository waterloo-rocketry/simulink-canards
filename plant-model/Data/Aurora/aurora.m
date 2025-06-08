%% OR Simulation Output Data
or_data = readtable("plant-model\Data\Aurora\aurora_cycle_2.csv");
or_override_aoa_cna = readtable("plant-model\Data\Aurora\aurora_cycle_2_cna_aoa.csv");
or_override_mach_cna = readtable("plant-model\Data\Aurora\aurora_cycle_2_cna_mach.csv");

%% Initial values
location = [250; 43.47; -80.54]; % launch location on earth. Altitude, Latitude, Longitude
rail_angle_pitch = deg2rad(-5); % Rail pitch angle. Negative is pitched downrange
rail_angle_yaw = deg2rad(0); % Rail yaw angle. Negative is yawed downrange
rail_length = 11.28; % [m]
time_idle = 5; % wait time on the rail before launch

%% Sensor mounting
sensor_1_d = [0.127; 0.074; -0.027]; % mounting location of IMU 1 relative CG
sensor_1_S = [0, 1, 0;
              0, 0, 1;
              1, 0, 0]; % mounting orientation of IMU 1 relative body frame
sensor_2_d = [0.127; 0.065; 0.047]; % mounting location of IMU 2 relative CG
sensor_2_S = [0, -1, 0;
              0, 0, 1;
              -1, 0, 0]; % mounting orientation of IMU 2 relative body frame

%% Actuator parameters
act_freq = 70; % natural frequency, approx 1/timeconstant
act_deadtime = 0.02; % delay in servo internal control loop
act_damping = 0.9; % damping ratio
act_backlash = 0.5; % play in deg
act_anglelimit = 12; % max deflection in deg
act_ratelimit = 600; % max rate in deg/s

%% Aerodynamics Reference Geometry
%Reference parameters   
rocket_diameter = 0.203; % reference length [m]
rocket_area_frontal = pi * rocket_diameter^2 / 4; % reference area [m^2]

% center of pressure location, for Cn_alpha override
rocket_pos_cp = -0.73; % [m]

% TEMP Cnalfa overrides - testflight
nosecone_CNa = 2;
body_CNa = 3;
fin_CNa = 7.225;
tail_CNa = 0;
canard_CNa = 2;

%Nosecone parameters
nosecone_length = 1.02; % nosecone length [m]
nosecone_radius = rocket_diameter / 2; % nosecone radius [m]

%Body parameters
rocket_length = 4.34; % rocket length [m]
body_length = rocket_length - nosecone_length; % fuselage length only [m]
body_surface_roughness = 20 / 10^6; % RMC(?) roughness 20 um smooth paint

%Fin parameters
fin_chord_root = 0.356; %[m] root chord?
fin_chord_tip = 0.178; %[m] tip chord?
fin_height = 0.216; %[m] height?
fin_sweep = 0.178; % [m]
fin_pos_x_roottip = -rocket_length + 0.054 + 0.391 - 0.013; % postion of fins measured from nosecone [m]
fin_number = 4; % Number of fins
fin_cant_angle_rad = deg2rad(0); % fin cant angle [rad]

%Tail parameters
tail_radius_outer = 0.203 / 2; % tail radius [m]
tail_length = 0.054; % tail length [m]
tail_radius_smallest = 0.19 / 2; % smallest tail radius(?) [m]
tail_pos_x_roottip = -rocket_length + tail_length; % tail position measured from nosecone

% Canards parameters 
canard_number = 2;
canard_chord_root = 3 * 0.0254; % root chord
canard_chord_tip = 1 / 1000; % tip chord 
canard_height = 1.5 * 0.0254; % root to tip length
canard_delta_max = deg2rad(12); % Canard maximum angle of attack
canard_pos_x_roottip = -(558.29 + 40)/1000; %TODO: add this