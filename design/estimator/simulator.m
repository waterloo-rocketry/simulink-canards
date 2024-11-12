T = 10; % sim end time
step = 0.01; % evaluation step width

u = 0; % control input 
u = u + [0; 0; 0];

% initials
q = [1; 0; 0; 0]; % orientation
w = [0; 0; 0]; % rates
v = [100; 0; 0]; % velocity
alt = 0; % altitude
CL = 1.5; % canard coefficient
delta = 0; % canard deflection 

x = [q; w; v; alt; CL; delta];

[t_solver,x_solver] = ode45(@(t, x_var)model_f(t, x_var, u), 0:step:T, x); %comment out accelerometer

%% plot 
