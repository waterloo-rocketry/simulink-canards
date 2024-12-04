function [K] = lqr_tune(x, Q, R)
    % returns gain vector for current state

    [F_roll, B, ~, ~] = model_roll(x);

    N = 0; % if desired cross term can be passed to lqr_tune

    K = -lqr(F_roll,B,Q,R,N);
end

