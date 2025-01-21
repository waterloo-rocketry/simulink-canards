%% Rocket body
m = 40; %mass in kg
Jx = 0.225; % inertia roll
Jy = 52; % inertia pitch, yaw
J = diag([Jx, Jy, Jy]);

length_cg = 0; % center of gravity
length_cp = -0.5; % center of pressure
area_reference = pi*(8*0.0254/2)^2; % cross section of body tube
Cn_alpha = 5; % pitch coefficent 
c_aero = Cn_alpha*area_reference*length_cp; % moment coefficient of body

%% Sensors
S_W = eye(3); % rotation transform from sensor frame to body frame
S_A = eye(3); % rotation transform from sensor frame to body frame
S_M = eye(3); % rotation transform from sensor frame to body frame
length_cs = [0; 0; 0]; % center of sensor frame

%% Canards, Actuator
tau = 1/60; % time constant of first order actuator dynamics
Cl_alpha = 1.5; % estimated coefficient of lift, const with Ma
tau_cl_alpha = 0.01; % time constant to converge Cl back to 1.5 in filter
area_canard = 0.002; % total canard area 
length_canard = 8*0.0254+0.05; % lever arm of canard to x-axis 
c_canard = area_canard*length_canard; % moment arm * area of canard

%% Environment
g = [-9.8; 0; 0]; % gravitational acceleration in the geographic inertial frame