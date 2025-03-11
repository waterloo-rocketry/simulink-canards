function [u] = controller_module(timestamp, input)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% stuff
    time_start = 5; % pad delay time
    t = timestamp - time_start;
    u_max = deg2rad(10); % cap output to this angle

    %% reference signal
    %%% includes multiple roll angle steps. Reference r [rad].

    r = 0;
    if t>5
        if t<12
            r = 1;
        elseif t<19
            r = -1;
        elseif t>26
            r = 0;
        end
    end

    %% compute controller output
    u = control_algorithm(input, r);

    %%% limit output to allowable angle
    u = min(max(u, -u_max), u_max);
end

