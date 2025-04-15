%% Parameters
aspect = 1.5; % aspect ratio
sweep = deg2rad(60); % sweep angle at quarter-chord 


%% variables
Mas = 0:0.01:3;
sweeps = deg2rad(50:5:70);

%% Computes
CL = zeros(length(Mas), 1);
for k=1:length(Mas)
    if Mas(k) <= 1
        cone(k) = 0;
        CL(k) = 2*pi*cot(sweep);
    else
        cone(k) = acos(1/Mas(k));
        if cone(k) > sweep
            CL(k) = 4 / sqrt(Mas(k)^2 - 1);
        else
            m = cot(sweep)/cot(cone(k));
            a = m*(0.38+2.26*m-0.86*m^2);
            CL(k) = 2*pi^2*cot(sweep) / (pi + a);
        end
    end
end

CLinear = zeros(length(Mas), 1);
for k=1:length(Mas)
    if Mas(k) <= 1
        CLinear(k) = 2*pi*cot(sweep);
    else
        slope = (2*pi-4.01)*cot(sweep) / (1 - 1/cos(sweep));
        CLinear(k) = 2*pi*cot(sweep) + slope * (Mas(k) - 1);
    end
end

% CL_sweeps = zeros(length(Mas), length(sweeps));
% for j = 1:length(sweeps)
%     for k=1:length(Mas)
%         if Mas(k) <= 1
%             cone(k) = 0;
%         else
%             cone(k) = acos(1/Mas(k));
%         end
%         if cone(k) > sweeps(j)
%             CL_sweeps(k,j) = 4 / sqrt(Mas(k)^2 - 1);
%         else
%             m = cot(sweeps(j))/cot(cone(k));
%             a = m*(0.38+2.26*m-0.86*m^2);
%             CL_sweeps(k,j) = 2*pi^2*cot(sweeps(j)) / (pi + a);
%         end
%     end
% end


%% plot
disp(['Max mach cone angle: ', num2str( rad2deg(acos(1/Mas(end))) ), ' deg' ]);

set(groot, 'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex')
set(groot, 'DefaultTextInterpreter', 'latex')

clf
figure(1)
plot(Mas, CL);
xlabel("Mach number")
ylabel("Coefficient of Lift")
hold on
plot(Mas, CLinear);
% yyaxis right
% plot(Mas, rad2deg(cone));
% yline(rad2deg(sweep), 'r--');
legend("$$C_L$$","$$C_{L, linear}$$", "Mach cone angle","Sweep angle")
% ylabel("Angles [deg]")
hold off

% figure(2)
% for j=1:length(sweeps)
%     name = strcat("Sweep ", num2str(rad2deg(sweeps(:,j))), "$$^\circ$$");
%     plot(Mas, CL_sweeps(:,j), 'DisplayName',name);
%     hold on
% end
% xlabel("Mach number")
% ylabel("Coefficient of Lift")
% legend
% hold off

set(groot, 'defaultAxesTickLabelInterpreter','remove')
set(groot, 'defaultLegendInterpreter','remove')
set(groot, 'DefaultTextInterpreter', 'remove')