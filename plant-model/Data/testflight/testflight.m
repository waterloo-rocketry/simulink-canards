%% OR Simulation Output Data
or_data = readtable("plant-model\Data\testflight\testflight_cycle_1_1_no_wind.csv");
or_override_aoa_cna = readtable("plant-model\Data\testflight\testflight_aoa_cna.csv");
or_override_mach_cna = readtable("plant-model\Data\testflight\testflight_mach_cna.csv");

%% Initial values
location = [250; 43.47; -80.54]; % launch location on earth. Altitude, Latitude, Longitude
rail_angle_pitch = deg2rad(-3); % Rail pitch angle. Negative is pitched downrange
rail_angle_yaw = deg2rad(2); % Rail yaw angle. Negative is yawed downrange
rail_length = 8.28; % delta-altitude for rail constraints
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
rocket_dist_cp = -0.3; % [m]

% TEMP Cnalfa overrides - testflight
nosecone_CNa = 2;
CNa_body = 3;
CNa_fins = 7.225;
CNa_tail = 0;
CNa_canard = 2;

%Nosecone parameters
nosecone_length = 1.02; % nosecone length [m]
nosecone_radius = rocket_diameter / 2; % nosecone radius [m]

%Body parameters
rocket_length = 2.72; % rocket length [m]
body_length = rocket_length - nosecone_length; % fuselage length only [m]
rocket_surface_roughness = 20 / 10^6; % RMC(?) roughness 20 um smooth paint

%Fin parameters
fin_chord_root = 0.254; %[m] root chord?
fin_chord_tip = 0.152; %[m] tip chord?
fin_height = 0.178; %[m] height?
fin_sweep = 0.0508; % [m]
pos_aletas = -rocket_length + 5.08/100; % postion of fins measured from nosecone [m]
N_fins = 4; % Number of fins
cant_angle_rad = deg2rad(0.175); % fin cant angle [rad]

%Tail parameters
rt = 0.152 / 2; % tail radius [m]
h = 0; % tail length [m]
r2 = 0.14 / 2; % smallest tail radius(?) [m]
pos_tail = -rocket_length + h; % tail position measured from nosecone

% Canards parameters 
N_canard = 2;
Cr_canard = 4 * 0.0254; % root chord
Ct_canard = 1 / 1000; % tip chord 
span_canard = 2.5 * 0.0254; % root to tip length
arm_canard = 1 * 0.0254; % Moment arm from fin to fuselage
alfa_canard = deg2rad(12); % Canard maximum angle of attack
pos_canard = -(558.29 + 40)/1000; %TODO: add this