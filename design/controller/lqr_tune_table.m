%% define dimensions
V_max = 300; % max velocity
C_max = 10; % max canard coefficient
C_min = -5; % min canard coefficient

% amount of design point for each dimension
P_size = 200; % dynamic pressure
C_size = 30; % coefficient of lift

%% tuning parameters
Q = diag([10, 2, 2]);
R = 1e2; % constant R. Can be scaled by dynamic pressure in loop
N = 0; % if desired cross term can be passed to lqr_tune
T_sample = 0.005; % sampling time of the loop
C = [1, 0, 0]; % output channel

%% prep table

% calculate air data
[~, ~, rho_max, ~] = model_airdata(0);

P_min = 100;
P_max = rho_max/2*V_max^2;

% Dimensions are (dynamic pressure, coefficent of lift)
Ps = linspace(P_min,P_max, P_size);
Cls = linspace(C_min, C_max, C_size);
Ps(Ps==0)=[];
Cls(Cls==0)=[];

[P_mesh,C_mesh] = meshgrid(Cls,Ps);

m = length(Ps);
n = length(Cls);
Ks = zeros(m,n,4); % length(x) is 3, plus 1 pre gain

%% fill table
clear model_roll
for i=1:m
    for k=1:n
        [F_roll, B, ~, ~] = model_roll(Ps(i), Cls(k));

        R = (Ps(i)) * 1e-4; % scale R by dynamic pressure

        K = -lqrd(F_roll,B,Q,R,N, T_sample);    
        Ks(i,k,1:3) = K;

        % sys_ol = c2d(ss(F_roll, B, eye(3), 0), T_sample);
        % [phi, gamma] = ssdata(sys_ol);
        % sys_cl = ss(phi+gamma*K, gamma, C, 0, T_sample);
        sys_cl = ss(F_roll+B*K, B, C, 0, T_sample);
        K_pre = 1 / dcgain(sys_cl);
        Ks(i,k,4) = K_pre;
    end
end    


%% save and export
%%% matlab .mat file
info.P_size = P_size; info.P_scale = (P_max-P_min)/P_size ; info.P_offset = P_min; 
info.C_size = C_size; info.C_scale = (C_max-C_min)/C_size; info.C_offset = C_min; 
save("design/controller/gains.mat", "Ks", "P_mesh", "C_mesh", "info");

%%% embedded .c file
run('schedule_file_creator.m')

%% Test responses
run("design-support\test\test_step.m")

%% Plot
if 0
    samplep = 1e5; samplec = 1.5;
    for i=1:4
        K(i) = interp2(P_mesh, C_mesh, Ks(:,:,i), samplec, samplep, 'linear');
    end
    
    figure(1)
    subplot(2,2,1)
    [P_plot,C_plot] = meshgrid(Cls,Ps);
    surfl(P_plot,C_plot,Ks(:,:,1), 'FaceAlpha',0.5)
    hold on
    scatter3(samplec, samplep ,K(1), 20, "k", "o", "filled")
    hold off
    xlabel("Coefficient")
    ylabel("Dynamic pressure")
    zlabel("K_\phi")
    zlim([-1,1])
    
    % figure(2)
    subplot(2,2,2)
    [P_plot,C_plot] = meshgrid(Cls,Ps);
    surfl(P_plot,C_plot,Ks(:,:,2), 'FaceAlpha',0.5)
    hold on
    scatter3(samplec, samplep ,K(2), 20, "k", "o", "filled")
    hold off
    xlabel("Coefficient")
    ylabel("Dynamic pressure")
    zlabel("K_{\omega_x}")
    zlim([-3,3])
    
    % figure(3)
    subplot(2,2,3)
    [P_plot,C_plot] = meshgrid(Cls,Ps);
    surfl(P_plot,C_plot,Ks(:,:,3), 'FaceAlpha',0.5)
    hold on
    scatter3(samplec, samplep ,K(3), 20, "k", "o", "filled")
    hold off
    xlabel("Coefficient")
    ylabel("Dynamic pressure")
    zlabel("K_\delta")
    zlim([-4,0])
    
    % figure(4)
    subplot(2,2,4)
    [P_plot,C_plot] = meshgrid(Cls,Ps);
    surfl(P_plot,C_plot,Ks(:,:,4), 'FaceAlpha',0.5)
    hold on
    scatter3(samplec, samplep ,K(4), 20, "k", "o", "filled")
    hold off
    xlabel("Coefficient")
    ylabel("Dynamic pressure")
    zlabel("K_{pre}")
    zlim([-1,1])
end