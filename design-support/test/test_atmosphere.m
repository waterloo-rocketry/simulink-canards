clear

alt = 0:0.1:40; % altitude in km

for i = 1:length(alt)
    [p_i, t_i, rho_i, mach_i] = model_airdata(alt(i)*1000);
    p(i) = p_i;
    t(i) = t_i;
    rho(i) = rho_i;
    mach(i) = mach_i;
end

%% Plot
set(groot, 'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex')
set(groot, 'DefaultTextInterpreter', 'latex')

figure(1)
plot(p/1000, alt)
yline([max(alt), 32, 20, 11],'--', {"Stratosphere2", "Stratosphere", "Tropopause", "Troposphere"},'LabelVerticalAlignment','bottom', 'Interpreter','latex')
ylim([min(alt), max(alt)])
ylabel("Altitude $$l$$ [km]")
xlabel("Pressure $$p$$ [kPa]")

figure(2)
plot(t, alt)
yline([max(alt), 32, 20, 11],'--', {"Stratosphere2", "Stratosphere", "Tropopause", "Troposphere"},'LabelVerticalAlignment','bottom', 'Interpreter','latex')
ylim([min(alt), max(alt)])
ylabel("Altitude $$l$$  [km]")
xlabel("Temperature $$T$$ [K]")

figure(3)
plot(rho, alt)
yline([max(alt), 32, 20, 11],'--', {"Stratosphere2", "Stratosphere", "Tropopause", "Troposphere"},'LabelVerticalAlignment','bottom', 'Interpreter','latex')
ylim([min(alt), max(alt)])
ylabel("Altitude $$l$$  [km]")
xlabel("Density $$\rho$$, [kg/m$$^{3}$$]")

% figure(4)
% plot(mach, alt)
% yline([max(alt), 32, 20, 11],'--', {"Stratosphere2", "Stratosphere", "Tropopause", "Troposphere"},'LabelVerticalAlignment','bottom', 'Interpreter','latex')
% ylim([min(alt), max(alt)])
% ylabel("Altitude $$l$$  [km]")
% xlabel("Speed of sound $$c$$ [m/s]")

set(groot, 'defaultAxesTickLabelInterpreter','remove')
set(groot, 'defaultLegendInterpreter','remove')
set(groot, 'DefaultTextInterpreter', 'remove')

