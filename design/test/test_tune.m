%% initials
q = [1; 0; 0; 0]; % orientation
w = [0.01; 0.01; 0.01]; % rates
v = [1000; 0; 0]; % velocity
alt = 600; % altitude
CL = 1.5; % canard coefficient
delta = 0.0; % canard deflection 

x = [q; w; v; alt; CL; delta];


%% test lqr
Q = diag([10, 0, 10]);
R = 1e4;
K= lqr_tune(x, Q, R)

[A, B, C, ~] = model_roll(x);

sys_cl = ss(A+B*K, B, C, 0);
K_pre = 1/dcgain(sys_cl(1))

%% Step
figure(1)
step(K_pre * sys_cl);
xlim([0,10]);

%% Simulink
linear_params
simout = sim("linear_sim.slx");
t_sim = simout.tout;
r_sim = simout.simout(:,1);
phi_sim = simout.simout(:,2);
p_sim = simout.simout(:,3);
delta_sim = simout.simout(:,4);
delta_u_sim = simout.simout(:,5);

%% Plot simulink
figure(2)
subplot(3,1,1)
plot(t_sim,phi_sim)
hold on
plot(t_sim,r_sim, "--k")
hold off
legend("phi","r")
xlabel("time t")
ylabel("rad")

subplot(3,1,2)
plot(t_sim,p_sim)
hold on
yline(0, "--k")
hold off
legend("p","r")
xlabel("time t")
ylabel("rad/s")

subplot(3,1,3)
plot(t_sim,delta_u_sim)
hold on
plot(t_sim,delta_sim)
hold off
legend("u", "delta")
xlabel("time t")
ylabel("rad")