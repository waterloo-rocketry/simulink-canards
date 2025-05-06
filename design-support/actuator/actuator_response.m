%% import 
table1 = readtable("Servo Response Data.xlsx", "Sheet","-10 to 10");
table2 = readtable("Servo Response Data.xlsx", "Sheet","0 to -10");
table3 = readtable("Servo Response Data.xlsx", "Sheet","0 to -5");
table4 = readtable("Servo Response Data.xlsx", "Sheet","0 to 5");
table5 = readtable("Servo Response Data.xlsx", "Sheet","0 to 10");

%% normalize

d1 = table2array(table1(:,2:3));
d2 = table2array(table2(1:end-3,2:3));
d3 = table2array(table3(:,2:3));
d4 = table2array(table4(:,2:3));
d5 = table2array(table5(:,2:3));

n1 = norm_data(d1);
n2 = norm_data(d2);
n3 = norm_data(d3);
n4 = norm_data(d4);
n5 = norm_data(d5);

figure(1)
plot(n1(:,1), n1(:,2));
hold on
plot(n2(:,1), n2(:,2));
plot(n3(:,1), n3(:,2));
plot(n4(:,1), n4(:,2));
plot(n5(:,1), n5(:,2));


%% step responses
sampling_time = 0.005;
tau = 0.06;
sys_est = c2d(tf(1, [tau, 1], 'InputDelay', sampling_time), sampling_time, "zoh");

omega = 70;
zeta = 0.9;
dead_time = 0.02;
sys_sim = tf(omega^2, [1, 2*zeta*omega, omega^2], 'InputDelay', dead_time);

figure(1)
hold on
step(sys_est, "b")
step(sys_sim, "k--")

xlim([0, 0.15])
hold off


%% function defs

function [normalized] = norm_data(data)
    normalized(:,1) = data(:,1) / 1000;
    offset = data(1,2);
    scale = data(end,2) - offset;
    for i = 1:length(data)
        normalized(i,2) = (data(i,2) - offset) / scale;
    end
end