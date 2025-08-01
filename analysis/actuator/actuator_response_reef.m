%% import 
table1 = readtable("reefs servo data.xlsx", "Sheet","Useful data 1");
table2 = readtable("reefs servo data.xlsx", "Sheet","useful data 2");
table3 = readtable("reefs servo data.xlsx", "Sheet","useful data 3");
table4 = readtable("reefs servo data.xlsx", "Sheet","useful data 4");

%% normalize

d1 = table2array(table1(:,1:2));
d2 = table2array(table2(:,1:2));
d3 = table2array(table3(:,1:2));
d4 = table2array(table4(:,1:2));

n1 = retime_data(norm_data(d1));
n2 = retime_data(norm_data(d2));
n3 = retime_data(norm_data(d3));
n4 = retime_data(norm_data(d4));

figure(1)
plot(n1(:,1), n1(:,2));
hold on
plot(n2(:,1), n2(:,2));
plot(n3(:,1), n3(:,2));
plot(n4(:,1), n4(:,2));
xlim([0,0.07]);
hold off

%% step responses
% max rate
hold on
t = 0:0.001:0.05;
plot(t, 480*t-1.5, 'k--')

sampling_time = 0.005;
tau = 0.03;
sys_est = 20*c2d(tf(1, [tau, 1], 'InputDelay', sampling_time), sampling_time, "zoh");

omega = 150;
zeta = 0.9;
dead_time = 0.02;
sys_sim = 20*tf(omega^2, [1, 2*zeta*omega, omega^2], 'InputDelay', dead_time);

figure(1)
hold on
step(sys_est, "b")
step(sys_sim, "k--")
xlim([0,0.07]);
hold off


%% function defs

function [normalized] = norm_data(data)
    normalized(:,1) = data(:,1);
    offset = data(1,2);
    % scale = data(end,2) - offset;
    scale = 1000 * sign(data(end,2) - offset);
    normalized(:,2) = (data(:,2) - offset) ./ scale;
end

function [retimed] = retime_data(data)
    index = find(abs(data(:,2)) > 1e-2, 2, 'first');
    retimed = data;
    retimed(1:index-2, :) = [];
    retimed(:,1) = retimed(:,1) - retimed(1,1);
end