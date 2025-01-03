%% Rocket body
m = 70; %mass in kg
Jx = 0.5; % inertia roll
Jy = 50; % inertia pitch, yaw
J = diag([Jx, Jy, Jy]);

length_cg = 0; % center of gravity
length_cp = -1; % center of pressure
area_reference = pi*(8*0.0254/2)^2; % cross section of body tube
Cn_alpha = 1; % pitch coefficent 
c_aero = Cn_alpha*area_reference*length_cp; % moment coefficient of body

%% Sensors
S_SW = eye(3); % rotation transform from sensor frame to body frame
S_SA = eye(3); % rotation transform from sensor frame to body frame
S_SM = eye(3); % rotation transform from sensor frame to body frame
length_cs = [0; 0; 0]; % center of sensor frame

%% Canards, Actuator
tau = 1/60; % time constant of first order actuator dynamics
Cl_alpha = 1.5; % estimated coefficient of lift, const with Ma
tau_cl_alpha = 0.01; % time constant to converge Cl back to 1.5 in filter
area_canard = 0.005; % total canard area 
length_canard = 8*0.0254+0.05; % lever arm of canard to x-axis 
c_canard = area_canard*length_canard; % moment arm * area of canard

%% Environment
g = [-9.8; 0; 0]; % gravitational acceleration in the geographic inertial frame

air_gamma = 1.4; % adiabatic index
air_R = 287.0579; % specific gas constant for air
air_atmosphere = [0, 101325, 288.15, 0.0065; % troposphere
                  11000, 22632.1, 216.65, 0; % tropopause
                  20000, 5474.9, 216.65, -0.001; % stratosphere
                  32000, 868.02, 228.65, -0.0028]; % stratosphere 2
                  % base height, P_base, T_base, lapse rate;
air_r0 = 6356766; % mean earth radius