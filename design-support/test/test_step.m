%% initials
CL = 4; % canard coefficient
alt = 1000; % altitude for dyn pressure
rho = model_airdata(alt).density;

V = linspace(30, 900, 20);
P = 0.5 * rho * V.^2;
steptime = 20;
T_sample = 0.005; % sampling time of the loop

clear control_scheduler
clear model_roll

%% test lqr + step
for i=1:length(P)   
    Ks = control_scheduler([P(i), CL]);
    K_pre = Ks(4);
    K = Ks(1:3);

    [A, B, C, ~] = model_roll(P(i), CL);
    sys_plant = c2d(ss(A, B, eye(3), 0), T_sample);
    [phi, gamma] = ssdata(sys_plant);

    %%% rolloff filter
    f_rolloff = 100; % [rad/s] rolloff frequency
    lowpass = c2d(tf(f_rolloff, [1, f_rolloff]), T_sample);

    sys_ol = K_pre * K * ss(phi, gamma, eye(3), 0, T_sample);% * lowpass;
    sys_cl = K_pre * ss(phi+gamma*K, gamma, eye(3), 0, T_sample);
    

    sys_array(:,:,1,i) = sys_cl;
    sys_array_open(:,:,1,i) = sys_ol;

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
%%
figure(3)
for i=1:length(P)   
    checkloopshape(sys_array_open(1,1,1,i), 20, 0.1, -20, 50)
    hold on
end
checkloopshape(ss(phi, gamma, [1,0,0], 0, T_sample), 20, 0.1, -20, 50)
hold off
% hold on
% bode(sys_min(1,1), 'g', sys_max(1,1), 'r')
% hold off

% [margin1, margin2] = margin(sys_array(1,1))
% [margin] = margin(sys_min(1,1), 'g', sys_max(1,1), 'r')