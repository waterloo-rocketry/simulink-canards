%% state
q = [1; 0; 0; 0]; % orientation
w = [0.01; 0.01; 0.01]; % rates
v = [600; 1; 5]; % velocity
alt = 200; % altitude
CL = 1.5; % canard coefficient
delta = 0.0; % canard deflection 

x = [q; w; v; alt; CL; delta];

u = 0.1; % control input 
A = [10; 2; 1]; % accelerometer measurement

u_ekf = cat(1, u, A);

% compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
S = model_quaternion_rotmatrix(q);

% compute roll angle       
phi = atan2(S(2,3)/S(3,3)); % double check if this is the correct angle

% cat roll state
x_roll = [phi; w(1); delta];

%% test lqr
Q = diag([10, 0, 10]);
R = 1e4;
K= lqr_tune(x, Q, R)

[A, B, C, ~] = model_roll(x);

sys_cl = ss(A+B*K, B, C, 0);
K_pre = 1/dcgain(sys_cl(1));
sys_cl = K_pre*sys_cl;

bode(sys_cl)

wb = bandwidth(sys_cl(1))
