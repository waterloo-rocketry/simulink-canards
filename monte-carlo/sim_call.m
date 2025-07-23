%% Configure
clear 
run('configure_plant_model');
save('monte-carlo/single/plant_model_baseline.mat');
clear

model_name = 'plant-model/CC_Flight_Simulation';

simin = Simulink.SimulationInput(model_name);
simin = simin.loadVariablesFromMATFile('monte-carlo/single/plant_model_baseline.mat');
simin = simin.setVariable('wind_const_strength', 10);
simin = simin.setVariable('canard_cant_zero', 0);

%% Run Sim

% clear(get_param('CC_Flight_Simulation','ModelWorkspace'))
simout = sim(simin, 'ShowProgress', 'on');

%% Post processing
[sdt, sdt_vars] = sim_postprocessor(simout);
[in_vars] = sim_postprocessor_in(simin, load('monte-carlo/single/plant_model_baseline.mat'));

%% Save 
save("monte-carlo/single/sim_recent.mat", "sdt", "sdt_vars", 'in_vars');
% load("monte-carlo/single/sim_recent.mat", "sdt", "sdt_vars");


%% Plots

% plot_animation(sdt_vars);

% figure(1)
% plot_state(sdt.rocket_dt, "\_sim", 'off');

figure(2)
plot_state(sdt.error, "");
sgtitle("Estimation Error")

% figure(3)
% stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
% legend("Reference", "Roll angle", "Roll control error")
% ylabel("Angle [deg]")

figure(4)
plots_1 = plot_state(sdt.est, "\_est", 'on');
plot_state(sdt.rocket_dt, "\_sim", 'off', plots_1);

figure(5)
sdt_array{1} = sdt;
plot_stats_covariance(sdt_array, 'P_norm', 'Covariance stats', [50 90])