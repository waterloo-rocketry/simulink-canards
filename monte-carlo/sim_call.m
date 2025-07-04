%% Run Sim

model_name = "plant-model/CC_Flight_Simulation";
model_handle = load_system(model_name);
model_workspace = get_param(model_handle, 'ModelWorkspace');
model_workspace.clear;
model_workspace.evalin('run(''configure_plant_model'')');
save_system(model_name);

simout = sim(model_name);

%% Post processing
[sdt, sdt_vars] = sim_postprocessor(simout);

%% Save 
save("monte-carlo/sim_recent.mat", "sdt", "sdt_vars");
% load("monte-carlo/sim_recent.mat", "sdt", "sdt_vars");


%% Plots

% plot_animation(sdt_vars);

% figure(1)
% plot(sdt.rocket.Time, sdt.rocket.q)
% hold on
% stairs(sdt.est.Time, sdt.est.q)
% hold off

% figure(2)
% subplot(2,3,1)
% stairs(sdt.error.Time, sdt.error.q)
% subplot(2,3,4)
% stairs(sdt.error.Time, sdt.error.w)
% subplot(2,3,2)
% stairs(sdt.error.Time, sdt.error.v)
% subplot(2,3,5)
% stairs(sdt.error.Time, sdt.error.alt)
% subplot(2,3,3)
% stairs(sdt.error.Time, sdt.error.cl)
% subplot(2,3,6)
% stairs(sdt.error.Time, sdt.error.delta)
% 
figure(2)
plot_est_dashboard(sdt.error, "");
sgtitle("Estimation Error")

figure(3)
stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
legend("Reference", "Roll angle", "Roll control error")
ylabel("Angle [deg]")

figure(4)
plots_1 = plot_est_dashboard(sdt.est, "\_est", 'on');
plot_est_dashboard(sdt.rocket_dt, "\_sim", 'off', plots_1);
