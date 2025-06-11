function [C_normal_alpha] = fin_online(C_normal_alpha_1, number, K_body)    

    % coefficients 
    C_normal_alpha_1 = K_body * C_normal_alpha_1;

    if number == 1 || number == 2
        C_normal_alpha = C_normal_alpha_1;
    elseif number == 3 
        C_normal_alpha = 1.5 * C_normal_alpha_1;
    elseif number == 4 
        C_normal_alpha = 2 * C_normal_alpha_1;
    end

end