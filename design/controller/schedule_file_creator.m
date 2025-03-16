%% Schedule file creator
% create .c file from gains.mat
% includes array of gains, array size information, 
% grid scaling and offset for input variables

%% load table
table = load("controller\gains.mat", "Ks", "info");

gain_amount = size(table.Ks, 3);

%% create and open .c file
fid = fopen('design\controller\controller_gains.c', 'w');

%% write file information
%%% header
fprintf(fid, '// Controller gains \n\n');

fprintf(fid, '// Conversion from flight conditions to natural table coordinates:\n');
fprintf(fid, '// int x_nat = (int) (x_fc - x_OFFSET) / x_SCALE; \n\n');

fprintf(fid, '// Array creation order: \n');
fprintf(fid, '// for gain_number = 1:gain_amount \n');
fprintf(fid, '//     for p = 1:P_size \n');
fprintf(fid, '//         for c = 1:C_size \n');
fprintf(fid, '//             Ks(p, c, gain_number)); \n\n');

%%% table information
fprintf(fid, '// Gain table information \n');
fprintf(fid, 'const int GAINS_AMOUNT = %d;\n\n', gain_amount);
fprintf(fid, 'const int GAINS_P_SIZE = %d;\n', table.info.P_size);
fprintf(fid, 'const int GAINS_C_SIZE = %d;\n\n', table.info.C_size);
fprintf(fid, 'const float GAINS_P_SCALE = %.4E;\n', table.info.P_scale);
fprintf(fid, 'const float GAINS_C_SCALE = %.4E;\n\n', table.info.C_scale);
fprintf(fid, 'const float GAINS_P_OFFSET = %.4E;\n', table.info.P_offset);
fprintf(fid, 'const float GAINS_C_OFFSET = %.4E;\n\n', table.info.C_offset);

%% write gain array
% for gain_number = 1:size(table.Ks, 3)
%     write_array(fid, table.Ks, gain_number, table.info.P_size, table.info.C_size)
% end
write_array2(fid, table.Ks, gain_amount, table.info.P_size, table.info.C_size)

%% close file
fclose(fid);

%% write array function definition
function [] = write_array2(fid, Ks, gain_amount, P_size, C_size)
    fprintf(fid, '// Gain array \n');
    fprintf(fid, 'const float gains[%d][%d] = \n{\n', gain_amount, P_size*C_size);
    for gain_number = 1:gain_amount
        fprintf(fid, '    // Gain %d = \n', gain_number);
        fprintf(fid, '    {\n     ');
        for p = 1:P_size
            for c = 1:C_size
                fprintf(fid, '%.4E', Ks(p, c, gain_number));
                if c < C_size
                    fprintf(fid, ', ');
                end
            end
            if p < P_size
                fprintf(fid, ',\n     ');
            end
        end
        if gain_number < gain_amount
            fprintf(fid, '\n    }, \n');
        else
            fprintf(fid, '\n    } \n');
        end
    end
    fprintf(fid, '};\n\n');
end

% %% write array function definition
% function [] = write_array(fid, Ks, gain_number, P_size, C_size)
%     fprintf(fid, '// Gain %d array \n', gain_number);
%     fprintf(fid, 'const float gain_%d[%d][%d] = \n{\n', gain_number, P_size, C_size);
%     for i = 1:P_size
%         fprintf(fid, '    {');
%         for j = 1:C_size
%             fprintf(fid, '%.4E', Ks(i, j, gain_number));
%             if j < C_size
%                 fprintf(fid, ', ');
%             end
%         end
%         fprintf(fid, '}');
%         if i < P_size
%             fprintf(fid, ',\n');
%         else
%             fprintf(fid, '\n');
%         end
%     end
%     fprintf(fid, '};\n\n');
% end