%% Choose rocket
% run('plant-model\Data\Borealis\borealis.m')
run('plant-model\Data\testflight\testflight.m')

%%% environment
run('plant-model\Data\Environment\environment.m')

%%% sensors
run('plant-model\Data\Sensors\sensors_processing.m')

%% data pre-processing
clear estimator_module
clear control_scheduler

run('plant-model\scripts\data_preparation.m')

%%% reference computations (used to check internal computation against OR net values only)
% Total normal force derivative
Cnalfa_ref = (nosecone_CNa + fin_CNa + tail_CNa + body_CNa + canard_CNa); 
% total CoP as weighted average of component CPs - do i need to multiply
% by fin_number?
x_ref = (nosecone_pos_x_cp * nosecone_CNa + fin_pos_x_cp * fin_CNa + tail_pos_x_cp * tail_CNa + body_CNa * body_pos_x_cp) / Cnalfa_ref; 