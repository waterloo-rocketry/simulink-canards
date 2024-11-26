function [K] = lqr_schedule(x)
    % determines feedback gain from states. Interpolates from look-up table
    % input: full state x
    % output: K = [phi, p, delta, pre]

    load("controller\gains.mat", "Ks", "P_mesh", "C_mesh");
    %%% K = Ks(p_dyn, Cl, 1:3)
    %%% K_pre = Ks(p_dyn, Cl, 4)

    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    v = x(8:10); alt = x(11); Cl = x(12); 

    % calculate air data
    [~, ~, rho, ~] = model_airdata(alt);
    airspeed = norm(v);
    p_dyn = rho/2*airspeed^2;
    
    K = zeros(4,1);
    for i=1:4
        K(i) = interp2(P_mesh, C_mesh, Ks(:,:,i), Cl, p_dyn, 'linear'); 
    end
end

