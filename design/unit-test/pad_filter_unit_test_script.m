%% NewContextOneIteration

% inputs

IMU_1 = [0.01; 0.02; -9.81; 0.001; -0.002; 0.0005; 0.3; 0.0; 0.4; 1013.25];
IMU_2 = [-0.02; 0.01; -9.78; 0.0005; 0.001; -0.001; 0.31; -0.01; 0.39; 1013.30];

% action

[x_init, bias_1, bias_2] = pad_filter(IMU_1, IMU_2);

% print outputs

SIZE_STATE = 13;
SIZE_IMU_ALL = 10;

fprintf('double x_expected[SIZE_STATE] = {\n');
for i = 1:SIZE_STATE
    if i < SIZE_STATE
        fprintf('    %.15g,\n', x_init(i));
    else
        fprintf('    %.15g\n', x_init(i));
    end
end
fprintf('};\n\n');

fprintf('double x_expected[SIZE_IMU_ALL] = {\n');
for i = 1:SIZE_IMU_ALL
    if i < SIZE_IMU_ALL
        fprintf('    %.15g,\n', bias_1(i));
    else
        fprintf('    %.15g\n', bias_1(i));
    end
end
fprintf('};\n\n');
fprintf('double x_expected[SIZE_IMU_ALL] = {\n');
for i = 1:SIZE_IMU_ALL
    if i < SIZE_IMU_ALL
        fprintf('    %.15g,\n', bias_2(i));
    else
        fprintf('    %.15g\n', bias_2(i));
    end
end
fprintf('};\n\n');