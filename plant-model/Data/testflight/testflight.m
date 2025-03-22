%% OR Simulation Output Data
or_data = readtable("plant-model\Data\testflight\testflight_cycle_1_1_no_wind.csv");
or_override_aoa_cna = readtable("plant-model\Data\testflight\testflight_aoa_cna.csv");
or_override_mach_cna = readtable("plant-model\Data\testflight\testflight_mach_cna.csv");
%% Initial values
location = [10; 43.47; -80.54]; % launch location on earth. Altitude, Latitude, Longitude
rail_angle = deg2rad(-5); % negative is pitched downrange
rail_length = 8.28; % delta-altitude for rail constraints
time_idle = 5; % wait time on the rail before launch

%% Sensor parameters
samplingrate = 0.005; % sampling period of the estimator
Ls1 = [-2.4;0;0]; % mounting location of IMU 1 relative CG
Ss1 = eye(3); % mounting orientation of IMU 1 relative body frame
Ls2 = [-2.5;0;0]; % mounting location of IMU 2 relative CG
Ss2 = eye(3); % mounting orientation of IMU 2 relative body frame

%% Actuator parameters
act_freq = 58; % natural frequency, approx 1/timeconstant
act_damping = 0.9; % damping ratio
act_backlash = 0.1; % play in deg
act_anglelimit = 45; % max deflection in deg
act_ratelimit = 600; % max rate in deg/s

%% Aerodynamics Reference Geometry
%Reference parameters   
Lr = 0.203; % reference length [m]
Ar = pi * (Lr^2) / 4; % reference area [m^2]

% center of pressure location, for Cn_alpha override
x_cp_tot = -2.1; % [m]

% TEMP Cnalfa overrides - testflight
CNa_nosecone = 2;
CNa_body = 3;
CNa_fins = 7.225;
CNa_tail = 0;
CNa_canard = 2;

%Nosecone parameters
logiva = 1.02; % nosecone length [m]
r0 = 0.203 / 2; % nosecone radius [m]

%Body parameters
l0 = 2.72; % rocket length [m]
lTubo = l0 - logiva; % fuselage length only [m]
Rs = 20 / 10^6; % RMC(?) roughness 20 um smooth paint

%Fin parameters
Cr = 0.254; %[m] root chord?
Ct = 0.152; %[m] tip chord?
span = 0.178; %[m] height?
sweep = 0.0508; % [m]
pos_aletas = -l0 + 5.08/100; % postion of fins measured from nosecone [m]
N_fins = 4; % Number of fins
cant_angle_rad = deg2rad(0); % fin cant angle [rad]

%Tail parameters
rt = 0.152 / 2; % tail radius [m]
h = 0; % tail length [m]
r2 = 0.14 / 2; % smallest tail radius(?) [m]
pos_tail = -l0 + h; % tail position measured from nosecone

% Canards parameters 
N_canard = 2;
Cr_canard = 40 / 1000;
Ct_canard = 40 / 1000; % "The tip is the size of the root to take advantage of the fact that the further away from the rocket, the greater the moment arm."
span_canard = 80 / 1000;
arm_canard = 10/1000; % Moment arm from fin to fuselage
alfa_canard = deg2rad(0); % Canard maximum angle of attack
pos_canard = -(558.29 + 40)/1000; %TODO: add this