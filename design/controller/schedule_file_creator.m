%% Schedule file creator
% create .c file from gains.mat
% includes array of gains, array size information, 
% grid scaling and offset for input variables

%% load table
table = load("controller\gains.mat", "Ks", "info");

gain_amount = size(table.Ks, 3);

%% create and open .c file
fid_h = fopen('design\controller\gain_table.h', 'w');
fid_c = fopen('design\controller\gain_table.c', 'w');

%% h file: write file information
%%% header
fprintf(fid_h, '#ifndef GAIN_TABLE_H_ \n #define GAIN_TABLE_H_\n\n');

fprintf(fid_h, '/**\n');
fprintf(fid_h, ' * Controller gains \n\n');

fprintf(fid_h, ' * Conversion from flight conditions to natural table coordinates:\n');
fprintf(fid_h, ' * int x_nat = (int) (x_fc - x_OFFSET) / x_SCALE; \n\n');

fprintf(fid_h, ' * Array creation order: \n');
fprintf(fid_h, ' * for gain_number = 1:gain_amount \n');
fprintf(fid_h, ' *      for p = 1:P_size \n');
fprintf(fid_h, ' *          for c = 1:C_size \n');
fprintf(fid_h, ' *              Ks(p, c, gain_number)); \n');
fprintf(fid_h, '*/\n\n');

%%% table information
fprintf(fid_h, '// Gain table information \n');
fprintf(fid_h, '#define GAIN_NUM %d;\n\n', gain_amount);
fprintf(fid_h, '#define GAIN_P_SIZE %d;\n', table.info.P_size);
fprintf(fid_h, '#define GAIN_C_SIZE %d;\n\n', table.info.C_size);

fprintf(fid_h, '#define PRESSURE_DYNAMIC_SCALE %.4E;\n', table.info.P_scale);
fprintf(fid_h, '#define CANARD_COEFF_SCALE %.4E;\n\n', table.info.C_scale);
fprintf(fid_h, '#define PRESSURE_DYNAMIC_OFFSET %.4E;\n', table.info.P_offset);
fprintf(fid_h, '#define CANARD_COEFF_OFFSET %.4E;\n\n', table.info.C_offset);

%%% array and end
fprintf(fid_h, 'extern const float gain_table[GAIN_NUM][GAIN_P_SIZE * GAIN_C_SIZE];\n\n');

fprintf(fid_h, '#endif // GAIN_TABLE_H_');

%% write gain array
fprintf(fid_c, '#include "application/controller/gain_table.h"\n\n');

write_array2(fid_c, table.Ks, gain_amount, table.info.P_size, table.info.C_size)

%% close file
fclose(fid_h);
fclose(fid_c);

%% write array function definition
function [] = write_array2(fid, Ks, gain_amount, P_size, C_size)
    fprintf(fid, '// Gain table \n');
    fprintf(fid, ['const float gain_table[GAIN_NUM][GAIN_P_SIZE * GAIN_C_SIZE] = {\n']);
    for gain_number = 1:gain_amount
        fprintf(fid, '    // Gain %d = \n', gain_number);
        fprintf(fid, '    {');
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
            fprintf(fid, '},\n');
        else
            fprintf(fid, '}\n');
        end
    end
    fprintf(fid, '};');
end