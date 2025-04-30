%% initials
CL = 2; % canard coefficient
alt = 1000; % altitude for dyn pressure
rho = model_airdata(alt).density;

V = linspace(20, 300, 20);
P = 0.5 * rho * V.^2;
steptime = 20;
T_sample = 0.005; % sampling time of the loop

clear control_scheduler
clear model_roll

%% test lqr + step
for i=1:length(P)   
    Ks = control_scheduler([P(i), CL]);
    K_pre = Ks(3);
    K = Ks(1:2);

    [A, B, C, ~] = model_roll(P(i), CL);
    sys_ol = c2d(ss(A, B, eye(2), 0), T_sample);
    [phi, gamma] = ssdata(sys_ol);
    sys_cl = K_pre*ss(phi+gamma*K, gamma, eye(2), 0, T_sample);

    sys_array(:,:,1,i) = sys_cl;

    if i == 1
        sys_min = sys_cl;
    elseif i == length(P)
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