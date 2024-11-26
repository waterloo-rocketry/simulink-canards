%% define dimensions
V_max = 1000; % max velocity
alt_max = 20e3; % max height (not relevant)
CL_max = 3; % max abs(coefficient)

% amount of design point for each dimension
P_amount = 100; % dynamic pressure
C_amount = 20; % coefficient of lift

%% tuning parameters
Q = diag([10, 0, 10]);
R = 1e4; % constant R. Can be scaled by dynamic pressure in loop
N = 0; % if desired cross term can be passed to lqr_tune

%% prep table

% calculate air data
[~, ~, rho_max, ~] = model_airdata(0);
[~, ~, rho_min, ~] = model_airdata(alt_max);

p_min = 0;
p_max = rho_max/2*V_max^2;

% Dimensions are (dynamic pressure, coefficent of lift)
Ps = linspace(p_min,p_max, P_amount);
Cls = linspace(-CL_max, CL_max, C_amount);
Ps(Ps==0)=[]
Cls(Cls==0)=[]

m = length(Ps);
n = length(Cls);
Ks = zeros(4,m,n); % length(x) is 3, plus 1 pre gain

%% fill table

for i=1:m
    for k=1:n
        [F_roll, B, ~, ~] = model_roll([], Ps(i), Cls(k));
        R = sqrt(Ps(i)) * 10; % scale R by dynamic pressure
        K = -lqr(F_roll,B,Q,R,N);    
        Ks(1:3,i,k) = K;
        sys_cl = ss(F_roll+B*K, B, eye(3), 0);
        K_pre = 1/dcgain(sys_cl(1));
        Ks(4,i,k) = K_pre;
    end
end    

%% save and export
save("controller/gains.mat", "Ks");