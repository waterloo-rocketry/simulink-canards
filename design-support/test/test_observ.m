%% state
q = rand(4,1); q = q/norm(q); % orientation
w = 2*rand(3,1); % rates
v = [200; 1; 5]; % velocity
alt = 2000; % altitude
CL = 1.5; % canard coefficient
delta = 0.1; % canard deflection 

x = [q; w; v; alt; CL; delta];

u.cmd = 0.0; % control input 
u.accel = rand(3,1); % accelerometer measurement

bias = rand(9,1);

dt = 0.005; 
t = 0;

%% determine jacobians
F_num = jacobian(@model_dynamics, dt, x, u);
F_an = model_dynamics_jacobian(dt, x, u);
% H_num = jacobian(@model_meas_imu, t, x, bias);
H_an = model_meas_imu_jacobian(t, x, bias);

F_diff = F_an - F_num
% H_diff = H_an - H_num

%% check observability, controllability

Ob_num = obsv(F_num, H_an);
observab_num = sprank(Ob_num)

Ob_an = obsv(F_an, H_an);
observab_an = sprank(Ob_an)

