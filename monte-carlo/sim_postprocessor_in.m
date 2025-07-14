function [in_vars] = sim_postprocessor_in(simin, baseline)
    % Saves simulation input data
    % Input parmaters: simin (Simulink.SimulationInput)
    % Output parameters: in_vars (struct with input variables)
    

    for i = 1:length(simin.Variables)
        var_struct = simin.Variables(i);
        in_vars_all.(var_struct.Name) = var_struct.Value;
    end

    in_both = intersect(fieldnames(in_vars_all), fieldnames(baseline));
    in_vars = rmfield(in_vars_all, in_both)
end