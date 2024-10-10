linear_params

V = 100;

q_bar = rho*V^2/2;

%%
L_p =  -10;                         % Roll damping derivative
L_d = q_bar*c_l_d*ref_area;      % Roll forcing derivative

%% State space formulation
A = [0, 1, 0;
     0, L_p/J, L_d/J;
     0, 0, -1/tau];
B = [0; 0; 1/tau];
C = eye(3);

sys = ss(A,B,C,0);

%% Controller
Q = diag([1,2,10]);
R = 1e4;        %1e1 for low speeds, 1e4 for high speeds
K = -lqr(sys,Q,R,0)

sys_cl = feedback(sys,-K);
K_pre = 1/dcgain(sys_cl(1,1));
sys_cl = K_pre * sys_cl/dcgain(sys_cl(1,1));

% Plot
%step(sys_cl);