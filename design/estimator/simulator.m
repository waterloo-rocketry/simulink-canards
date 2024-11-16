T = 15; % sim end time
step = 0.01; % evaluation step width

u = 0.1; % control input 
u = cat(1, u, [0; 0; 0]);

% initials
q = [0; 1; 0; 0]; % orientation
w = [0; 0.01; 0]; % rates
v = [100; 0; 0]; % velocity
alt = 0; % altitude
CL = 1.5; % canard coefficient
delta = 0; % canard deflection 

x = [q; w; v; alt; CL; delta];

[t_solver,x_solver] = ode45(@(t_, x_var)model_f(t_, x_var, u), 0:step:T, x); %comment out accelerometer

%% plot 

%rotation
for t = 1:length(t_solver)
    q = x_solver(t,1:4);
    S = model_quaternion_rotmatrix(q);
    pointing = cat(2,pointing,S*[1;0;0]);
end
figure(1)
plot3(pointing(3,:),pointing(2,:), pointing(1,:))

figure(2)
plot(t_solver, x_solver(:,1:4))
figure(3)
plot(t_solver, x_solver(:,5:7))
figure(4)
plot(t_solver, x_solver(:,8:10))
figure(5)
plot(t_solver, x_solver(:,11))