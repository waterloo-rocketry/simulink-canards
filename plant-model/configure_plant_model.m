%% Choose rocket
% run('plant-model/Data/Borealis/borealis.m')
% run('plant-model/Data/testflight/testflight.m')
run('plant-model/Data/Aurora/aurora.m')

%%% Settings
chute_enable = [1, 1]; % no recovery is = 0
time_idle = 240; % wait time on the rail before launch
rail_angle_pitch = deg2rad(-6);

%%% environment
run('plant-model/Data/Environment/environment.m')
% enable wind disturbances
wind_dist_enable = 1; % no disturbances is = 0

%%% sensors
run('plant-model/Data/Sensors/sensors_processing.m')
sensor_fault_enable = [0, 0, 0]; % no faults is = 0

%% data pre-processing
run('plant-model/scripts/data_preparation.m')

%% Controller and Estimator loading
clear estimator_module
clear control_scheduler
design_param = load('model/model_params.mat');
