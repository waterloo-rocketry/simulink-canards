%% OR Simulation Output Data
or_data = readtable('plant-model/Data/Aurora/aurora_cycle_3.csv');
% or_override_aoa_cna = readtable('plant-model/Data/Aurora/aurora_cycle_2_cna_aoa.csv');
% or_override_mach_cna = readtable('plant-model/Data/Aurora/aurora_cycle_2_cna_mach.csv');

%% Initial values
location = [420; 43.47; -80.54]; % launch location on earth. Altitude, Latitude, Longitude
rail_angle_pitch = deg2rad(-5); % Rail pitch angle. Negative is pitched downrange
rail_angle_yaw = deg2rad(0); % Rail yaw angle. Negative is yawed downrange
rail_angle_roll = deg2rad(0); % Rocket clocking angle. 
rail_length = 11.28; % [m]

%% Sensor mounting
sensor_1_d = [-1.83; 0.074; -0.027]; % mounting location of IMU 1 relative nosetip
sensor_1_S = [0, 1, 0;
              0, 0, 1;
              1, 0, 0]; % mounting orientation of IMU 1 relative body frame
sensor_2_d = [-1.83; 0.065; 0.047]; % mounting location of IMU 2 relative nosetip
sensor_2_S = [0, -1, 0;
              0, 0, 1;
              -1, 0, 0]; % mounting orientation of IMU 2 relative body frame

%% Actuator parameters
act_freq = 150; % natural frequency, approx 1/timeconstant
act_deadtime = 0.02; % delay in servo internal control loop
act_damping = 0.9; % damping ratio
act_backlash = 0.5; % play in deg
act_anglelimit = 12; % max deflection in deg
act_ratelimit = 480; % max rate in deg/s

%% Misc Rocket parameters
engine_thrust_factor = 0.85; % perfomance gain
canard_roll_reversal_factor = 1; % coefficient gain

%% Aerodynamics Reference Geometry
%Reference parameters   
rocket_diameter = 0.203; % reference length [m]
rocket_area_frontal = pi * rocket_diameter^2 / 4; % reference area [m^2]
rocket_length = 5.11; % rocket length [m]

%Parachutes
time_chute_drogue = 55; % time from liftoff to 1st deployment
time_chute_main = 220; % time from liftoff to 1st deployment
chute_drogue_drag = 0.55 * 0.82; % Cd * A [m^2]
chute_main_drag = 1.23 * 8.36; % Cd * A [m^2]
chute_pos_x = -1.1; % chute attachment [m]

%Nosecone parameters
nosecone_length = 1.02; % nosecone length [m]
nosecone_radius = rocket_diameter / 2; % nosecone radius [m]

%Tail parameters
tail_radius_outer = 0.203 / 2; % tail radius [m]
tail_length = 0.0533; % tail length [m]
tail_radius_smallest = 0.19 / 2; % smallest tail radius(?) [m]
tail_pos_x_roottip = -rocket_length + tail_length; % tail position measured from nosecone

%Body parameters
body_length = rocket_length - nosecone_length - tail_length; % fuselage length only [m]
body_surface_roughness = 20 / 10^6; % RMC(?) roughness 20 um smooth paint

%Fin parameters
fin_chord_root = 0.406; %[m] root chord?
fin_chord_tip = 0.0762; %[m] tip chord?
fin_height = 0.216; %[m] height?
fin_sweep = 0.33; % [m]
fin_sweep_angle = deg2rad(56.8); % angle from radial normal [rad]
fin_pos_x_roottip = - ( rocket_length - tail_length - 0.475 - 0.0172 ); % position of fins measured from nosecone [m]
fin_number = 4; % Number of fins
fin_cant_angle_rad = deg2rad(0); % fin cant angle [rad]

% Canards parameters 
canard_number = 2;
canard_chord_root = 0.102; % root chord
canard_chord_tip = 0.001; % tip chord 
canard_height = 0.0508; % root to tip length
canard_sweep_angle = deg2rad(60.3); % angle from radial normal [rad]
canard_delta_max = deg2rad(12); % Canard maximum angle of attack
canard_pos_x_roottip = - (nosecone_length + 0.241 + 0.518 + 0.102 - 0.0254); % position of the most forward tip of the canards
canard_cant_zero = deg2rad(0); % zero roll not perfect