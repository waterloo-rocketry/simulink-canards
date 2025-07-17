function [u, r] = controller_module(timestamp, input)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% settings
    time_launch = 5; % pad delay time
    time_coast = 10; % time from launch to burnout
    u_max = deg2rad(10); % cap output to this angle

    %% Reference signal
    % Generates reference signal for roll program
    % includes multiple roll angle steps. Reference r [rad].
    
    t = timestamp - time_launch;
    r = 0;
    if t > (time_coast + 5)
        if t < (time_coast + 12)
            r = 0.5;
        elseif t < (time_coast + 19)
            r = -0.5;
        elseif t < (time_coast + 26)
            r = 0.5;
        elseif t > (time_coast + 35)
            r = 0;
        end
    end

    %% controller algorithm
    % Computes control output. Uses gain schedule table and simplified roll model
    % Inputs: roll state input(1:3), flight conditions input(4:5), reference signal r
    % Outputs: control input u

    roll_state = input(1:3); 
    flight_cond = input(4:5);

    %%% Gain scheduling
    Ks = zeros(1,4);
    % get gain from schedule
    Ks = control_scheduler(flight_cond);
    K = Ks(1:3);
    K_pre = Ks(4);
    
    %%% Feedback law
    % two degree of freedom, full state feedback + feedforward
    u = K*roll_state + K_pre*r; 

    %%% limit output to allowable angle
    u = min(max(u, -u_max), u_max);

    if t < time_coast % disable during boost
        u = 0;
    end
end

