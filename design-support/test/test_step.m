%% initials
q = [1; 0; 0; 0]; % orientation
w = [0.01; 0.01; 0.01]; % rates
v = [100; 0; 0]; % velocity
alt = 1000; % altitude
CL = 1.5; % canard coefficient
delta = 0.0; % canard deflection 

x = [q; w; v; alt; CL; delta];

V = linspace(30, 800, 40);
steptime = 10;
T_sample = 0.005; % sampling time of the loop

%% test lqr + step
for i=1:length(V)
    x(8) = V(i);
    
    if 1 % isempty(table)
        table = load("design/controller/gains.mat", "Ks", "P_mesh", "C_mesh");
    end
    Ks = control_scheduler(table, x);
    K_pre = Ks(4);
    K = Ks(1:3);

    [A, B, C, ~] = model_roll(x);
    sys_ol = c2d(ss(A, B, eye(3), 0), T_sample);
    [phi, gamma] = ssdata(sys_d_ol);
    sys_cl = K_pre*ss(phi+gamma*K, gamma, eye(3), 0, T_sample);

    sys_array(:,:,1,i) = sys_cl;

    if i == 1
        sys_min = sys_cl;
    elseif i == length(V)
        sys_max = sys_cl;
    end
    % step(sys_cl, steptime);
    % hold on
end

%% Figure
figure(1)
step(sys_array, steptime)
hold on
step(sys_min, 'g', sys_max, 'r', steptime)
hold off

figure(2)
bode(sys_array(1,1))
hold on
bode(sys_min(1,1), 'g', sys_max(1,1), 'r')
hold off