function [u] = control_algorithm(input, r)
    % Computes control output. Uses gain schedule table and simplified roll model
    % Inputs: full state x, reference signal r
    % Outputs: control input u
    
    persistent table; 

    if isempty(table)
        table = load("controller\gains.mat", "Ks", "P_mesh", "C_mesh");
    end

    %% Gain scheduling
    Ks = zeros(1,4);
    % get gain from schedule
    Ks = control_scheduler(table, input(4:5));
    K = Ks(1:3);
    K_pre = Ks(4);
    
    %% Feedback law
    u = K*input(1:3) + K_pre*r; %two degree of freedom, full state feedback + feedforward
end

