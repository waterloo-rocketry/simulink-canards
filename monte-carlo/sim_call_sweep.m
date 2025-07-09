%% Configure
clear 
run('configure_plant_model');
save('monte-carlo/plant_model_baseline.mat');
clear

model_name = "plant-model/CC_Flight_Simulation";

%% Sweep parameters
number_simulations =5;

%%% nominal
rocket_thrust_var = 1;
wind_const_var = 0;
wind_gust_var = 0;
canard_coefficient_var = 1;
canard_backlash_var = 0.1;
fin_cant_var = 0;


%%% sweeps
rocket_thrust_var = 0.8:0.05:1.2;
wind_const_var = 0:50:100;
wind_gust_var = 0:5:40;
canard_coefficient_var = -1:0.1:3;
canard_backlash_var = 0:0.1:5;
fin_cant_var = 0:0.01:0.1;

% Sweep create
possible_combinations = length(rocket_thrust_var) * length(wind_const_var) * ...
                        length(wind_gust_var) * length(canard_coefficient_var) * ...
                        length(canard_backlash_var) * length(fin_cant_var)

for i = 1:number_simulations
    simin(i) = Simulink.SimulationInput(model_name);

    simin(i) = simin(i).loadVariablesFromMATFile('plant_model_baseline.mat');
    
    simin(i) = simin(i).setVariable('var_thrust', randomsampling(rocket_thrust_var));
    simin(i) = simin(i).setVariable('wind_const_strength',randomsampling(wind_const_var));
    simin(i) = simin(i).setVariable('var_wind_gust',randomsampling(wind_gust_var));
    simin(i) = simin(i).setVariable('var_canard_coeff',randomsampling(canard_coefficient_var));
    simin(i) = simin(i).setVariable('act_backlash',randomsampling(canard_backlash_var));
    simin(i) = simin(i).setVariable('var_fin_cant',randomsampling(fin_cant_var));
end

function value = randomsampling(vector)
    index = randsample(length(vector), 1);
    value = vector(index);
end

%% Run Sim

% save_system(model_name,[],'OverwriteIfChangedOnDisk',true);
simout = parsim(simin, 'ShowProgress', 'on')
close_system(model_name, 0);
delete(gcp('nocreate'));

%% Post processing

for k = 1:number_simulations
    [sdt, sdt_vars] = sim_postprocessor(simout(k));
    filename = sprintf("monte-carlo/batch/sim_%d.mat", k);
    save(filename, "sdt", "sdt_vars");
end