%% Choose rocket

run('plant-model\Data\Borealis\borealis.m')
%run('plant-model\Data\Aurora\aurora.m')
% run('plant-model\Data\testflight\testflight.m')

%% data pre-processing
clear estimator_module

run('plant-model\scripts\data_preparation.m')

% TEMP Cnalfa overrides
CNa_nosecone = 2;
CNa_body = 5;
CNa_fins = 9.6;
CNa_tail = -0.319;
CNa_canard = 2;

%%% reference computations (used to check internal computation against OR net values only)
% Total normal force derivative
Cnalfa_ref = (CNa_nosecone + CNa_fins + CNa_tail + CNa_body + CNa_canard); 
% total CoP as weighted average of component CPs
x_ref = (x_pos_nosecone * CNa_nosecone + x_pos_fins * CNa_fins + x_pos_tail * CNa_tail + CNa_body * x_pos_bodytube) / Cnalfa_ref; 