%% Configure
batch_name = '_ascent_200';
number_simulations = 200;
P_threshold = 2000;
stop_time = 55; % 55 is apogee, 240 is after main deploy

%% load baseline
clearvars -except batch_name number_simulations P_threshold stop_time
run('configure_plant_model');
mkdir(sprintf('monte-carlo/batch%s/', batch_name))
save(sprintf('monte-carlo/batch%s/plant_model_baseline.mat', batch_name))
clearvars -except batch_name number_simulations P_threshold stop_time
model_name = 'plant-model/CC_Flight_Simulation';

%% Sweep parameters

%%% nominal
rocket_thrust_exp = 1;
wind_const_exp = 10;
wind_gust_exp = 10;
canard_coefficient_exp = 1;
canard_backlash_exp = 0.25;
canard_cant_exp = 0.1;


%%% sweeps
rocket_thrust_var = 0.85 :0.05: 1.05;
wind_const_var = 0 :1: 20;
wind_gust_var = 0 :1: 20;
canard_coefficient_var = -1 :0.1: 2;
canard_backlash_var = 0 :0.1: 1;
canard_cant_var = 0 :0.1: 0.5;

% Sweep create
% possible_combinations = length(rocket_thrust_var) * length(wind_const_var) * ...
%                         length(wind_gust_var)^2 * length(canard_coefficient_var) * ...
%                         length(canard_backlash_var) * length(canard_cant_var)

for i = 1:number_simulations
    simin(i) = Simulink.SimulationInput(model_name);
    simin(i) = setModelParameter(simin(i),"StopTime", num2str(stop_time));

    simin(i) = simin(i).loadVariablesFromMATFile(sprintf('monte-carlo/batch%s/plant_model_baseline.mat', batch_name));

    simin(i) = simin(i).setVariable('engine_thrust_factor', normalsampling(rocket_thrust_var, rocket_thrust_exp));
    simin(i) = simin(i).setVariable('wind_const_strength',normalsampling(wind_const_var, wind_const_exp));
    simin(i) = simin(i).setVariable('wind_gust1_amplitude',normalsampling(wind_gust_var, wind_gust_exp));
    simin(i) = simin(i).setVariable('wind_gust2_amplitude',normalsampling(wind_gust_var, wind_gust_exp));
    simin(i) = simin(i).setVariable('canard_roll_reversal_factor',normalsampling(canard_coefficient_var, canard_coefficient_exp));
    simin(i) = simin(i).setVariable('act_backlash',normalsampling(canard_backlash_var, canard_backlash_exp));
    simin(i) = simin(i).setVariable('canard_cant_zero',normalsampling(canard_cant_var, canard_cant_exp));
end

function value = randomsampling(vector)
    index = randsample(length(vector), 1);
    value = vector(index);
end

function value = normalsampling(vector, mean_val)
    std_dev = (max(vector) - min(vector)) / 4;  % 95% of values in range
    value = mean_val + std_dev * randn();
    value = max(min(value, max(vector)), min(vector)); % Clip to the range of the vector
end

%% Run Sim

% save_system(model_name,[],'OverwriteIfChangedOnDisk',true);
% clear(get_param(model_name,'ModelWorkspace'));
close_system(model_name, 0);
simout = parsim(simin, 'ShowProgress', 'on')
close_system(model_name, 0);
% delete(gcp('nocreate'));

%% Post processing

error_count = 0;
error_id = [];
unstable_count = 0;
unstable_id = [];
for k = 1:number_simulations
    [in_vars] = sim_postprocessor_in(simin(k), load(sprintf('monte-carlo/batch%s/plant_model_baseline.mat', batch_name)));
    [sdt, sdt_vars] = sim_postprocessor(simout(k));
    filename = sprintf('monte-carlo/batch%s/sim_%d.mat', batch_name, k);
    save(filename, 'sdt', 'in_vars');
    if ~isempty(simout(k).ErrorMessage)
        error_id(end+1) = k;
    elseif any(sdt.P_norm.P_norm(:,end) > P_threshold, 'all')
        unstable_id(end+1) = k;
    end
end

error_id
error_count = length(error_id)
error_ratio = error_count / number_simulations
unstable_id
unstable_count = length(unstable_id)
unstable_ratio = unstable_count / number_simulations


filename = sprintf('monte-carlo/batch%s/result_summary.mat', batch_name);
save(filename, 'number_simulations', 'error_id', 'error_count', 'error_ratio', 'unstable_id', 'unstable_count', 'unstable_ratio');