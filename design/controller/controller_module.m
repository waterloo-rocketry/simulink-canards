function [u] = controller_module(timestamp, roll_state, flight_cond)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% settings
    time_start = 5; % pad delay time
    u_max = deg2rad(10); % cap output to this angle
    backlash = deg2rad(0); % backlash offset

    %% Reference signal
    % Generates reference signal for roll program
    % includes multiple roll angle steps. Reference r [rad].
    
    t = timestamp - time_start;
    r = 0;
    if t>2
        if t<8
            r = 0.5;
        elseif t<14
            r = -0.5;
        elseif t>22
            r = 0;
        end
    end

    %% controller algorithm
    % Computes control output. Uses gain schedule table and simplified roll model
    % Inputs: roll state input(1:3), flight conditions input(4:5), reference signal r
    % Outputs: control input u

    %%% Gain scheduling
    Ks = zeros(1,3);
    % get gain from schedule
    Ks = control_scheduler(flight_cond);
    K = Ks(1:2);
    K_pre = Ks(3);
    
    %%% Feedback law
    % two degree of freedom, full state feedback + feedforward
    u = K*roll_state + K_pre*r; 

    %%% backlash offset
    if u > 0
        u = u + backlash;
    elseif u < 0
        u = u - backlash;
    end

    %%% limit output to allowable angle
    u = min(max(u, -u_max), u_max);
end

