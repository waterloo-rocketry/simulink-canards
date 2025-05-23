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
clear alti_module

run('plant-model\scripts\data_preparation.m')

%%% reference computations (used to check internal computation against OR net values only)
% Total normal force derivative
Cnalfa_ref = (CNa_nosecone + CNa_fins + CNa_tail + CNa_body + CNa_canard); 
% total CoP as weighted average of component CPs
x_ref = (x_pos_nosecone * CNa_nosecone + x_pos_fins * CNa_fins + x_pos_tail * CNa_tail + CNa_body * x_pos_bodytube) / Cnalfa_ref; 