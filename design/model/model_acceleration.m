function [a] = model_acceleration(x, A)
    % Top-level controller module. Calls controller algorithm. Sets reference signal.
    
    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    w = x(5:7); v = x(8:10); 

    % decompose input vector: [delta_u(1), A(3)]
    % A = u(2:end);
    
    global IMU_select

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end
    
    %% average acceleration measurements
    %%% acceleration specific force
    a = zeros(3,1);
    %%% average specific force of selected sensors
    for k = 1:length(IMU_select)
        if IMU_select(k) == 1
            dk = param.d_k(:, k);
            ak = A( 3*(k-1)+1 : 3*k ) - cross(w, cross(w, dk)); % - cross(w_dot, dk);
            a = a + ak/(length(A)/3);
        end
    end

end

