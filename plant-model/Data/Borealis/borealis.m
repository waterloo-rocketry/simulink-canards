%% OR Simulation Output Data
or_data = readtable("plant-model\Data\Borealis\Borealis_flight_no_wind.csv");
or_override_aoa_cna = readtable("plant-model\Data\Borealis\borealis_aoa_cna.csv");
or_override_mach_cna = readtable("plant-model\Data\Borealis\borealis_mach_cna.csv");

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
act_deadtime = 0.02; % delay in servo internal control loop
act_damping = 0.9; % damping ratio
act_backlash = 0.1; % play in deg
act_anglelimit = 12; % max deflection in deg
act_ratelimit = 600; % max rate in deg/s

%% Aerodynamics Reference Geometry
%Reference parameters   
Lr = 0.152; % reference length [m]
Ar = pi * (Lr^2) / 4; % reference area [m^2]

% center of pressure location, for Cn_alpha override
x_cp_tot = -3.17; % [m]

% TEMP Cnalfa overrides - borealis
CNa_nosecone = 2;
CNa_body = 5;
CNa_fins = 9.6;
CNa_tail = -0.319;
CNa_canard = 2;

%Nosecone parameters
logiva = 0.638; % nosecone length [m]
r0 = 0.152 / 2; % nosecone radius [m]

%Body parameters
l0 = 4.05; % rocket length [m]
lTubo = l0 - logiva; % fuselage length only [m]
Rs = 20 / 10^6; % RMC(?) roughness 20 um smooth paint

%Fin parameters
Cr = 0.254; %[m] root chord?
Ct = 0.229; %[m] tip chord?
span = 0.178; %[m] height?
sweep = 0.114; % [m]
pos_aletas = -l0 + (28.3+7.94-1.27)/100; % postion of fins measured from nosecone [m]
N_fins = 3; % Number of fins
cant_angle_rad = deg2rad(0); % fin cant angle [rad]

%Tail parameters
rt = 0.152 / 2; % tail radius [m]
h = 0.0794; % tail length [m]
r2 = 0.14 / 2; % smallest tail radius(?) [m]
pos_tail = -l0 + h; % tail position measured from nosecone

% Canards parameters 
N_canard = 2;
Cr_canard = 76 / 1000; % root chord
Ct_canard = 1 / 1000; % tip chord 
span_canard = 25 / 1000; % root to tip length
arm_canard = 10/1000; % Moment arm from fin to fuselage
alfa_canard = deg2rad(12); % Canard maximum angle of attack
pos_canard = -(558.29 + 40)/1000; %TODO: add this