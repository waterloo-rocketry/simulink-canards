clear

%% Launch site
elevation = 250; % m above sea level

%% Rocket body
m = 26; %mass in kg
Jx = 0.2; % inertia roll
Jy = 10.1; % inertia pitch, yaw
J = diag([Jx, Jy, Jy]);
Jinv = inv(J);

length_cg = 0; % center of gravity
length_cp = -0.3; % center of pressure
area_reference = pi*(0.203/2)^2; % cross section of body tube
c_aero = area_reference * (length_cp-length_cg);
Cn_alpha = 12; % pitch forcing coefficent 
Cn_alpha = 20; % different ref area?
Cn_omega = 0; % pitch damping coefficent 


%% Actuator
tau_est = 0.07; % time constant of first order actuator dynamics, in estimation
tau_ctr = 0.04; % time constant of first order actuator dynamics, for controller tuning


%% Canards
%%% aerodynamics
area_canard = 2 * 0.102 * 6.35; % total canard area 
length_canard = 0.203/2+0.0254; % lever arm of canard to x-axis 
c_canard = area_canard*length_canard; % moment arm * area of canard

%%% airfoil theory
tau_cl_alpha = 2; % time constant to converge Cl back to theoretical value in filter
canard_sweep = deg2rad(54.5);
canard_sweep_cot = cot(canard_sweep);
Cl_alpha = 2*pi*canard_sweep_cot; % estimated coefficient of lift, const with Ma
canard_mach_supercrit = 1/cos(canard_sweep);
canard_slope_linear = (2*pi - 4.01) * canard_sweep_cot / (1 - 1/cos(canard_sweep));


%% Environment
g = [-9.81; 0; 0]; % gravitational acceleration in the geographic inertial frame


%% Sensors
S1 = eye(3); % IMU 1, rotation transform from sensor frame to body frame
S2 = eye(3); % IMU 2, rotation transform from sensor frame to body frame
S_k = cat(3, S1, S2);

d1 = [0; 0; 0]; % center of sensor frame
d2 = [0; 0; 0]; % center of sensor frame

B1 = eye(3); % Soft iron compensation
B2 = eye(3); % Soft iron compensation
b1 = [0;0;0]; % Hard iron compensation
b2 = [0;0;0]; % Hard iron compensation

%% save and export
save("design/model/model_params.mat");