function [in_vars] = sim_postprocessor_in(simin, baseline)
    % Saves simulation input data
    % Input parmaters: simin (Simulink.SimulationInput)
    % Output parameters: in_vars (struct with input variables)
    
    % extract from simin
    for i = 1:length(simin.Variables)
        var_struct = simin.Variables(i);
        in_vars.(var_struct.Name) = var_struct.Value;
    end

    % save only difference from baseline
    in_both = intersect(fieldnames(in_vars), fieldnames(baseline));
    for i = 1:length(in_both)
        field = in_both{i};
        if isequaln(in_vars.(field), baseline.(field))
            in_vars = rmfield(in_vars, field);
        end
    end
end