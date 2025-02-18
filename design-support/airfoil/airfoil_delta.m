%% Parameters
aspect = 1; % aspect ratio
sweep = deg2rad(60); % sweep angle at quarter-chord 


%% variables
Mas = 0:0.01:3;
sweeps = deg2rad(45:5:80);

%% Computes
CL = zeros(length(Mas), 1);
for k=1:length(Mas)
    if Mas(k) <= 1
        cone(k) = 0;
    else
        cone(k) = acos(1/Mas(k));
    end
    if cone(k) > sweep
        CL(k) = 4 / sqrt(Mas(k)^2 - 1);
    else
        m = cot(sweep)/cot(cone(k));
        a = m*(0.38+2.26*m-0.86*m^2);
        CL(k) = 2*pi^2*cot(sweep) / (pi + a);
    end
end

CL_sweeps = zeros(length(Mas), length(sweeps));
for j = 1:length(sweeps)
    for k=1:length(Mas)
        if Mas(k) <= 1
            cone(k) = 0;
        else
            cone(k) = acos(1/Mas(k));
        end
        if cone(k) > sweeps(j)
            CL_sweeps(k,j) = 4 / sqrt(Mas(k)^2 - 1);
        else
            m = cot(sweeps(j))/cot(cone(k));
            a = m*(0.38+2.26*m-0.86*m^2);
            CL_sweeps(k,j) = 2*pi^2*cot(sweeps(j)) / (pi + a);
        end
    end
end


%% plot
disp(['Max mach cone angle: ', num2str( rad2deg(acos(1/Mas(end))) ), ' deg' ]);

clf
figure(1)
plot(Mas, CL);
xlabel("Mach number")
ylabel("Coefficient of Lift")
hold on
yyaxis right
plot(Mas, rad2deg(cone));
yline(rad2deg(sweep), 'r--');
legend("CL", "mach cone","sweep")
ylabel("Angles [deg]")
hold off

figure(2)
for j=1:length(sweeps)
    plot(Mas, CL_sweeps(:,j));
    hold on
end
xlabel("Mach number")
ylabel("Coefficient of Lift")
hold off