function [u] = controller_module(t, x)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    % reference signal
    %%% includes multiple roll angle steps. Reference r [rad].
    if t>10
        if t<15
            r = 1;
        elseif t<25
            r = -1;
        elseif t>25
            r = 0;
        end
    else
        r = 0;
    end

    % compute controller output
    u = lqr_algorithm(x, r);
end

