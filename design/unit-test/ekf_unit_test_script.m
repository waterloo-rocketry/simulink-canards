
% === SIZE DEFINITIONS ===
SIZE_STATE = 13;

% === STATE VECTOR ===
x = [
    2.426878243614206; 4.001402344444001; 0.709431693136077; 2.108806413131375; 4.578677625945335; 3.961036647797772; 4.797462131964515; 3.278703495782934; 0.178558392870948; 4.245646529343886; 4.669966238787753; 3.393675774288867; 3.788700652891667


];

% === ZERO INITIAL COVARIANCE ===
P_diag_arr = [2.95219117313746;
0.50150522974397;
0.31864903478599;
1.11722922016661;
0.59435520762892;
1.46906291404807;
1.01848024017227;
2.85489139433318;
2.76099611950969;
0.15803099304238;
2.21357428655099;
0.80735827919567;
1.26850684502642];

P = diag(P_diag_arr);

% === INPUT STRUCT ===
u.accel = [1.456126946168524; 2.400841406666400; 0.425659015881646];
u.cmd = 0.547870901214845;

% encoder
encoder = 0.431651170248720;

% === TIME STEP ===
dt = 1.038711463665142;

% === PROCESS R_MTI ===
R = diag([1e-6, 1e-6, 1e-6, 2e-3, 2e-3, 2e-3, 2e1]);

% imu select
global IMU_select;
IMU_select = [1 0];

% IMU array
IMU_1 = [2.711216972515416;
4.238310136658316;
2.074393441904026;
7.598779134258502;
1.752878606103443;
2.033296028751589;
1.536372424330727;
2.048978680348982;
3.921288156935092;
2.799920579853715
];

IMU_2 = [7.387037136825951;
3.441659130636672;
1.478530560993089;
7.239047749439143;
7.837987026848682;
3.510959785008826;
0.888953787524790;
2.064517567296535;
3.269758768900417;
4.759168592068915

];

% bias array 
b.bias_1 = [0.942736984276934;
0.417744104316662;
0.983052466469856;
0.301454948712065;
0.701098755900926;
0.666338851584426;
0.539126465042857;
0.698105520180308;
0.666527913402587;
0.178132454400338

];

b.bias_2 = [0.128014399720173;
0.999080394761361;
0.171121066356432;
0.032600820530528;
0.561199792709660;
0.881866500451810;
0.669175304534394;
0.190433267179954;
0.368916546063895;
0.460725937260412

];


disp("IMU_1 select")
% === CALL CORRECTION ===
[x, P] = ekf_algorithm(x, P, b, dt, dt, IMU_1, IMU_2, u.cmd, encoder, 0);

% === PRINT C-STYLE OUTPUTS ===

% STATE
fprintf('// Predicted State (x_expected)\n');
fprintf('double x_expected[SIZE_STATE] = {\n');
for i = 1:SIZE_STATE
    if i < SIZE_STATE
        fprintf('    %.15g,\n', x(i));
    else
        fprintf('    %.15g\n', x(i));
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
            fprintf('    %.15g,', P(i, j));
        else
            fprintf('    %.15g\n', P(i, j));
        end
    end
end

fprintf('};\n');


% disp("IMU_2 select")
% % imu_2 corr
% x_new = xhat;
% P_new = Phat;
% 
% [xhat, Phat] = ekf_correct(@model_meas_imu, @model_meas_imu_jacobian, x_new, P_new, IMU_2(4:end), b.bias_2, R);
% 
% % STATE
% fprintf('// Predicted State (x_expected)\n');
% fprintf('double x_expected[SIZE_STATE] = {\n');
% for i = 1:SIZE_STATE
%     if i < SIZE_STATE
%         fprintf('    %.15g,\n', xhat(i));
%     else
%         fprintf('    %.15g\n', xhat(i));
%     end
% end
% fprintf('};\n\n');
% 
% % COVARIANCE MATRIX FLATTENED
% fprintf('// Predicted Covariance (P_expected)\n');
% fprintf('double P_expected[SIZE_STATE * SIZE_STATE] = {\n');
% for i = 1:SIZE_STATE
%     for j = 1:SIZE_STATE
%         idx = (i - 1) * SIZE_STATE + j;
%         if idx < SIZE_STATE^2
%             fprintf('    %.15g,', Phat(i, j));
%         else
%             fprintf('    %.15g\n', Phat(i, j));
%         end
%     end
% end
% 
% fprintf('};\n');