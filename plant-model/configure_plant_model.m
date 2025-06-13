clear
%% Choose rocket
% run('plant-model\Data\Borealis\borealis.m')
% run('plant-model\Data\testflight\testflight.m')
run('plant-model\Data\Aurora\aurora.m')

%%% environment
run('plant-model\Data\Environment\environment.m')
% enable wind disturbances
wind_dist_enable = 0; % no disturbances is = 0

%%% sensors
run('plant-model\Data\Sensors\sensors_processing.m')

%% data pre-processing
run('plant-model\scripts\data_preparation.m')


%% Controller and Estimator loading
clear estimator_module
clear control_scheduler
design_param = load("model\model_params.mat");
