%% Configure

model_name = "plant-model/CC_Flight_Simulation";
model_handle = load_system(model_name);
model_workspace = get_param(model_handle, 'ModelWorkspace');
model_workspace.clear;
model_workspace.evalin('run(''configure_plant_model'')');


%% Sweep parameters
number_simulations = 10;

%%% nominal
rocket_thrust_var = 1;
wind_const_var = 0;
wind_gust_var = 0;
canard_coefficient_var = 1;
canard_backlash_var = 0.1;
fin_cant_var = 0;


%%% sweeps
rocket_thrust_var = 0.8:0.05:1.2;
wind_const_var = 0:1:20;
wind_gust_var = 0:1:20;
canard_coefficient_var = -1:0.1:3;
canard_backlash_var = 0:0.1:5;
fin_cant_var = 0:0.01:0.1;

% Sweep create
possible_combinations = length(rocket_thrust_var) * length(wind_const_var) * ...
                        length(wind_gust_var) * length(canard_coefficient_var) * ...
                        length(canard_backlash_var) * length(fin_cant_var)

for i = 1:number_simulations
    simin(i) = Simulink.SimulationInput(model_name);

    simin(i) = simin(i).setVariable('var_thrust', randomsampling(rocket_thrust_var));
    simin(i) = simin(i).setVariable('var_wind_const',randomsampling(wind_const_var));
    simin(i) = simin(i).setVariable('var_wind_gust',randomsampling(wind_gust_var));
    simin(i) = simin(i).setVariable('var_canard_coeff',randomsampling(canard_coefficient_var));
    simin(i) = simin(i).setVariable('var_canard_backlash',randomsampling(canard_backlash_var));
    simin(i) = simin(i).setVariable('var_fin_cant',randomsampling(fin_cant_var));

    % thrust = in(i).Variables(1).Value
    % wind_const = in(i).Variables(2).Value
    % wind_gust = in(i).Variables(3).Value
    % canard_coeff = in(i).Variables(4).Value
    % canard_backlash = in(i).Variables(5).Value
    % fin_cant = in(i).Variables(6).Value
end

function value = randomsampling(vector)
    index = randsample(length(vector), 1);
    value = vector(index);
end

%% Run Sim

save_system(model_name);
% simout = sim("plant-model\CC_Flight_Simulation");
simout = parsim(simin, 'ShowProgress', 'on', 'UseFastRestart', true)

%% Post processing

for k = 1:number_simulations
    [sdt, sdt_vars] = sim_postprocessor(simout(k));
    filename = sprintf("monte-carlo/batch/sim_%d.mat", k);
    save(filename, "sdt", "sdt_vars");
end


%% Plot

number_plots = 10;

for k = 1:number_plots
    filename = sprintf("monte-carlo/batch/sim_%d.mat", k);
    load(filename, "sdt", "sdt_vars");

    if k == 1
        figure(1)
        plots_err = plot_est_dashboard(sdt.error, "", 'on');
        sgtitle("Estimation Error")

        figure(2)
        stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
        hold on
        % legend("Reference", "Roll angle", "Roll control error")
        ylabel("Angle [deg]")
        
        figure(3)
        plots_est = plot_est_dashboard(sdt.est, "\_est", 'on');
        plot_est_dashboard(sdt.rocket_dt, "\_sim", 'on', plots_est);

    elseif k == number_plots
        figure(1)
        plot_est_dashboard(sdt.error, "", 'off', plots_err);
        sgtitle("Estimation Error")
        
        figure(2)
        stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
        hold off
        % legend("Reference", "Roll angle", "Roll control error")
        ylabel("Angle [deg]")
        
        figure(3)
        plot_est_dashboard(sdt.est, "\_est", 'on', plots_est);
        plot_est_dashboard(sdt.rocket_dt, "\_sim", 'off', plots_est);
        
    else
        figure(1)
        plot_est_dashboard(sdt.error, "", 'on', plots_err);
        sgtitle("Estimation Error")
        
        figure(2)
        stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
        % legend("Reference", "Roll angle", "Roll control error")
        ylabel("Angle [deg]")
        
        figure(3)
        plot_est_dashboard(sdt.est, "\_est", 'on', plots_est);
        plot_est_dashboard(sdt.rocket_dt, "\_sim", 'on', plots_est);
    end
end