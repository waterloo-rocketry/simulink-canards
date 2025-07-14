function [in_vars] = sim_postprocessor_in(simin)
    % Saves simulation input data
    % Input parmaters: simin (Simulink.SimulationInput)
    % Output parameters: in_vars (struct with input variables)
    

    for i = 1:length(simin.Variables)
        var_struct = simin.Variables(i);
        in_vars.(var_struct.Name) = var_struct.Value;
    end
end