clear

%% Rocket body
m = 26.2; %mass in kg
Jx = 0.17; % inertia roll
Jy = 11; % inertia pitch, yaw
J = diag([Jx, Jy, Jy]);
Jinv = inv(J);

length_cg = 0; % center of gravity
length_cp = -0.5; % center of pressure
area_reference = pi*(0.203/2)^2; % cross section of body tube
c_aero = area_reference * (length_cp-length_cg);
Cn_alpha = 5; % pitch forcing coefficent 
Cn_omega = 0; % pitch damping coefficent 

%% Actuator
tau = 1/20; % time constant of first order actuator dynamics


%% Canards
tau_cl_alpha = 2; % time constant to converge Cl back to 1.5 in filter
area_canard = 2 * (4 * 0.0254) * (2.5 * 0.0254); % total canard area 
length_canard = 0.203/2+0.0254; % lever arm of canard to x-axis 
c_canard = area_canard*length_canard; % moment arm * area of canard
canard_sweep = deg2rad(60);
canard_sweep_cot = cot(canard_sweep);
Cl_alpha = 2*pi*canard_sweep_cot; % estimated coefficient of lift, const with Ma
canard_mach_supercrit = 1/cos(canard_sweep);
canard_slope_linear = (2*pi - 4.01) * canard_sweep_cot / (1 - 1/cos(canard_sweep));

%% Environment
g = [-9.81; 0; 0]; % gravitational acceleration in the geographic inertial frame

%% Sensors
S1 = eye(3); % IMU 1, rotation transform from sensor frame to body frame
S2 = eye(3); % IMU 2, rotation transform from sensor frame to body frame
S3 = eye(3); % IMU 3, rotation transform from sensor frame to body frame
S_k = cat(3, S1, S2, S3);

d1 = [0; 0; 0]; % center of sensor frame
d2 = [0; 0; 0]; % center of sensor frame
d3 = [0; 0; 0]; % center of sensor frame

B1 = eye(3); % Soft iron compensation
B2 = eye(3); % Soft iron compensation
B3 = eye(3); % Soft iron compensation
b1 = [0;0;0]; % Hard iron compensation
b2 = [0;0;0]; % Hard iron compensation
b3 = [0;0;0]; % Hard iron compensation

%% save and export
save("design/model/model_params.mat");