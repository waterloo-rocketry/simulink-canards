clear

%% Sensors
S1 = eye(3); % IMU 1, rotation transform from sensor frame to body frame
S2 = eye(3); % IMU 2, rotation transform from sensor frame to body frame
S3 = eye(3); % IMU 3, rotation transform from sensor frame to body frame
S_k = [S1, S2, S3];
d1 = [0; 0; 0]; % center of sensor frame
d2 = [0; 0; 0]; % center of sensor frame
d3 = [0; 0; 0]; % center of sensor frame
d_k = [d1, d2, d3];

B1 = eye(3); % Soft iron compensation
B2 = eye(3); % Soft iron compensation
B3 = eye(3); % Soft iron compensation
b1 = [0;0;0]; % Hard iron compensation
b2 = [0;0;0]; % Hard iron compensation
b3 = [0;0;0]; % Hard iron compensation


%% Rocket body
m = 40; %mass in kg
Jx = 0.225; % inertia roll
Jy = 52; % inertia pitch, yaw
J = diag([Jx, Jy, Jy]);

length_cg = 0; % center of gravity
length_cp = -0.5; % center of pressure
area_reference = pi*(8*0.0254/2)^2; % cross section of body tube
c_aero = area_reference * (length_cp-length_cg);
Cn_alpha = 5; % pitch forcing coefficent 
Cn_omega = 0; % pitch damping coefficent 

%% Canards, Actuator
tau = 1/40; % time constant of first order actuator dynamics
Cl_alpha = 1.5; % estimated coefficient of lift, const with Ma
tau_cl_alpha = 2; % time constant to converge Cl back to 1.5 in filter
area_canard = 0.02; % total canard area 
length_canard = 8*0.0254/2+0.05; % lever arm of canard to x-axis 
c_canard = area_canard*length_canard; % moment arm * area of canard

%% Environment
g = [-9.8; 0; 0]; % gravitational acceleration in the geographic inertial frame

%% save and export
save("design/model/model_params.mat");