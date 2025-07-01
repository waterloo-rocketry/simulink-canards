
% === SIZE DEFINITIONS ===
SIZE_STATE = 13;

% === STATE VECTOR ===
x = [1:13]'
size(x)

% === INPUT STRUCT ===
u.accel = [5;77;9];
u.cmd = 8;

% === TIME STEP ===
dt = 0.32;



% === CALL PREDICTION ===
[x_new] = model_dynamics(dt, x, u);

% === PRINT C-STYLE OUTPUTS ===

% STATE
fprintf('// est state (x_expected)\n');
fprintf('double x_expected[13] = {\n');
for i = 1:SIZE_STATE
    if i < SIZE_STATE
        fprintf('    %.15g,\n', x_out(i));
    else
        fprintf('    %.15g\n', x_out(i));
    end
end
fprintf('};\n\n');


