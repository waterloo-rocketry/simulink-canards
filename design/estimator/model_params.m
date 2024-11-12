%% Rocket body
m = 70; %mass in kg
Jx = 0.5; % inertia roll
Jy = 50; % inertia pitch, yaw
J = diag([Jx, Jy, Jy]);

length_cg = 0; % center of gravity
length_cp = 0; % center of pressure

%% Sensors
S_s = eye(3); % rotation transform from sensor frame to body frame
length_cs = 0; % center of sensor frame

%% Canards, Actuator
tau = 1/60; % time constant of first order actuator dynamics
Cl_alpha = 1.5; % estimated coefficient of lift, const with Ma
area_canard = 0.005; % total canard area 
length_canard = 8*0.0254+0.05; % lever arm of canard to x-axis 
c_canard = Cl_alpha*area_canard*length_canard; % moment coefficient area of canard

%% Environment
g = [-9.8; 0; 0]; % gravitational acceleration in the geographic inertial frame

air_gamma = 1.4; % adiabatic index
air_R = 8.31446 / 0.0289644; % specific gas constant for air
air_atmosphere = [101325, 288.15, 0.0065, 0; % troposphere
                  22632.1, 216.65, 0, 11000; % tropopause
                  5474.9, 216.65, -0.001, 20000; % stratosphere
                  868.02, 228.65, -0.0028, 32000]; % stratopause
                  % P_base, T_base, lapse rate, base height;