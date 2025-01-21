function [u] = controller_module(timestamp, x)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% stuff
    t = timestamp;
    r = 0;

    %% reference signal
    %%% includes multiple roll angle steps. Reference r [rad].
    if t>10
        if t<15
            r = 1;
        elseif t<25
            r = -1;
        elseif t>25
            r = 0;
        end
    end

    %% compute controller output
    u = control_algorithm(x, r);
end

