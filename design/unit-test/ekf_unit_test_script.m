
% === SIZE DEFINITIONS ===
SIZE_STATE = 13;

% === STATE VECTOR ===
x = [
    0.814723686393179;
    0.905791937075619;
    0.126986816293506;
    0.913375856139019;
    0.632359246225410;
    0.097540404999410;
    0.278498218867048;
    0.546881519204984;
    0.957506835434298;
    0.964888535199277;
    0.157613081677548;
    0.970592781760616;
    0.957166948242946
];

% === ZERO INITIAL COVARIANCE ===
P = zeros(SIZE_STATE);

% === INPUT STRUCT ===
u.accel = [1.456126946168524; 2.400841406666400; 0.425659015881646];
u.cmd = 4.217612826262750;

% === TIME STEP ===
dt = 0.915735525189067;

% === PROCESS NOISE MATRIX Q ===
Q = diag([ones(1,4)*1e-9, ones(1,3)*1e-2, ones(1,3)*1e-3, 1e-3,  30, 0.5]);


% === CALL PREDICTION ===
[x_out, P_out] = ekf_predict(@model_dynamics, @model_dynamics_jacobian, x, P, u, Q, dt);

% === PRINT C-STYLE OUTPUTS ===

% STATE
fprintf('// Predicted State (x_expected)\n');
fprintf('double x_expected[SIZE_STATE] = {\n');
for i = 1:SIZE_STATE
    if i < SIZE_STATE
        fprintf('    %.15g,\n', x_out(i));
    else
        fprintf('    %.15g\n', x_out(i));
    end
end
fprintf('};\n\n');

% COVARIANCE MATRIX FLATTENED
fprintf('// Predicted Covariance (P_expected)\n');
fprintf('double P_expected[SIZE_STATE * SIZE_STATE] = {\n');
for i = 1:SIZE_STATE
    for j = 1:SIZE_STATE
        idx = (i - 1) * SIZE_STATE + j;
        if idx < SIZE_STATE^2
            fprintf('    %.15g,', P_out(i, j));
        else
            fprintf('    %.15g\n', P_out(i, j));
        end
    end
end

fprintf('};\n');
