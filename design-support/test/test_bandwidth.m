%% initials
CL = 4; % canard coefficient
alt = 1000; % altitude for dyn pressure
rho = model_airdata(alt).density;

V = linspace(20, 900, 40);
P = 0.5 * rho * V.^2;
steptime = 20;
T_sample = 0.01; % sampling time of the loop

clear control_scheduler
clear model_roll

%% test lqr + step
for i=1:length(P)   
    Ks = control_scheduler([P(i), CL]);
    K_pre = Ks(end);
    K = Ks(1:end-1);

    [A, B, C, ~] = model_roll(P(i), CL);
    sys_plant = c2d(ss(A, B, eye(3), 0), T_sample);
    [phi, gamma] = ssdata(sys_plant);

    %%% rolloff filter
    f_rolloff = 100; % [rad/s] rolloff frequency
    lowpass = c2d(tf(f_rolloff, [1, f_rolloff]), T_sample);

    sys_ol = K_pre * K * ss(phi, gamma, eye(3), 0, T_sample);
    % sys_ol = K_pre * K * ss(phi, gamma, eye(3), 0, T_sample) * lowpass;
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

w_low = 0.1;
L_low = 20;

w_high = 2*pi*10;
L_high = -20;

figure(1)
for i = 1 : 3 : length(P)   
    checkloopshape(sys_array_open(1,1,1,i), L_low, w_low, L_high, w_high)
    % checkloopshape(L,Llbd,wlbd,Lubd,wubd)
    % inputs:   L -> loop transfer function (must be siso!)
    %           Llbd -> in db, lower bound for the loop gain at low frequencies
    %           wlbd -> in rad/s, frequency below which |L| shall be larger than |Llbd|
    %           Lubd -> in db, upper bound for the loop gain at high frequencies
    %           wubd -> in rad/s, frequency above which |L| shall be less than |Lubd|
    hold on
end
checkloopshape(ss(phi, gamma, [1,0,0], 0, T_sample),  L_low, w_low, L_high, w_high)
hold off
% hold on
% bode(sys_min(1,1), 'g', sys_max(1,1), 'r')
% hold off

% [margin1, margin2] = margin(sys_array(1,1))
% [margin] = margin(sys_min(1,1), 'g', sys_max(1,1), 'r')