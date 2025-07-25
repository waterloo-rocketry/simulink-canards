% inputs: x, P, R, encoder
x = [
    2.426878243614206; 4.001402344444001; 0.709431693136077; 2.108806413131375; 4.578677625945335; 3.961036647797772; 4.797462131964515; 3.278703495782934; 0.178558392870948; 4.245646529343886; 4.669966238787753; 3.393675774288867; 3.788700652891667


];

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



R = 0.01;
encoder = 0.431651170248720; 

% action
[xhat, Phat] = ekf_correct(@model_meas_encoder, @model_meas_encoder_jacobian, x, P, encoder, 0, R);

% print 
% STATE
fprintf('// Predicted State (x_expected)\n');
fprintf('double x_expected[SIZE_STATE] = {\n');
for i = 1:SIZE_STATE
    if i < SIZE_STATE
        fprintf('    %.15g,\n', xhat(i));
    else
        fprintf('    %.15g\n', xhat(i));
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
            fprintf('    %.15g,', Phat(i, j));
        else
            fprintf('    %.15g\n', Phat(i, j));
        end
    end
end

fprintf('};\n');