function [in_vars] = sim_postprocessor_in(simin)
    % Saves simulation input data
    % Input parmaters: simin (Simulink.SimulationInput)
    % Output parameters: in_vars (struct with input variables)
    
    N = length(simin.Variables);

    for i = 1:N
        var_struct = simin.Variables(i);
        in_vars(i) = assignin('caller', var_struct.Name, var_struct.Value);
    end
end