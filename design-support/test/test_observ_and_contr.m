%% state
q = [1; 0; 0; 0]; % orientation
w = [0.01; 0.01; 0.01]; % rates
v = [100; 1; 5]; % velocity
alt = 2000; % altitude
CL = 1.5; % canard coefficient
delta = 0.0; % canard deflection 

x = [q; w; v; alt; CL; delta];

u = 0.1; % control input 
A = [10; 2; 1]; % accelerometer measurement

u_ekf = cat(1, u, A);

% compute rotational matrix (attitude transformation matrix, between body frame and ground frame)
S = model_quaternion_rotmatrix(q);

    % compute roll angle       
    phi = S(2,3)/S(3,3); % double check if this is the correct angle
    
    % cat roll state
    x_roll = [phi; w(1); delta];

%% determine jacobians
step = 0.01; % evaluation step width
t = 0;

F = jacobian(@model_f, t, x, u_ekf, step);
H = jacobian(@model_h, t, x, u_ekf, step);
B = [zeros(length(x)-1, 1); 1];
%%
step = 0.01;
    F_roll = jacobian(@model_f_roll, t, x_roll, u, step, x); 
    B_roll = [zeros(length(x_roll)-1, 1); 1]; % this should be replaced with proper function, its fine but not future proof


%% check observability, controllability
[Abar,Bbar,Cbar,T,k] = obsvf(F,B,H, 1e-5);
[Abar,Bbar,Cbar,T,k] = ctrbf(F,B,H, 1e-5);

Ob = obsv(F, H);
observab = sprank(Ob)

Co = ctrb(F, B);
controllab = rank(Co)

Co_roll = ctrb(F_roll, B_roll);
controllab_roll = rank(Co_roll)
