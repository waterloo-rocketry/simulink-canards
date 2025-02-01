function [u] = controller_module(timestamp, x)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% stuff
    t = timestamp;
    r = 0;
    u_max = deg2rad(20); % cap output to this angle

    %% reference signal
    %%% includes multiple roll angle steps. Reference r [rad].
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
    u = control_algorithm(x, r);

    %%% limit output to allowable angle
    u = min(max(u, -u_max), u_max);
end

