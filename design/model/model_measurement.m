function [y] = model_measurement(t, x, b)
    % Computes measurement prediction using current state and sensor biases

    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); a = x(8:10); v = x(11:13); alt = x(14); Cl = x(15); delta = x(16);

    % decompose bias matrix: [b_A(3,i); b_W(3, i); M_E(3, i); b_P(1, i)]
    b_W = b(4:6,:); M_E = b(7:9,:);

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end

    %% compute rotation matrix 
    %%% attitude transformation, inertial to body frame
    S = quaternion_rotmatrix(q);

    %% acceleration
    if isreal(w)
        A = zeros(3*size(b,2), 1);
    else
        A = 1i*zeros(3*size(b,2), 1);
    end
    for k = 1:size(b,2)
        dk = param.d_k(:, k);
        A(3*(k-1)+1 : 3*k) = a + cross(w, cross(w, dk)); % + cross(w_dot, dk);% 
    end   
    
    %% rates
    if isreal(w)
        W = zeros(3*size(b,2), 1);
    else
        W = 1i*zeros(3*size(b,2), 1);
    end
    for k = 1:size(b,2)
        W(3*(k-1)+1 : 3*k) = w + b_W(:,k); % sensor bias
    end
 

    %% magnetic field model
    if isreal(q)
        M = zeros(3*size(b,2), 1);
    else
        M = 1i*zeros(3*size(b,2), 1);
    end
    for k = 1:size(b,2)
        M(3*(k-1)+1 : 3*k) = S*M_E(:,k); % % Earth magnetic field in body frame 
        % TODO: add iron corrections
    end

    %% atmosphere model
    P = zeros(size(b,2), 1);
    if isreal(w)
        P = zeros(size(b,2), 1);
    else
        P = 1i*zeros(size(b,2), 1);
    end
    for k = 1:size(b,2)
        [Pk, ~, ~, ~] = model_airdata(alt);
        P(k) = Pk;
    end
    
    %% canard angle
    D = delta;

    %% filtered quaternion
    Q = q;

    %% measurement prediction
    y = [A; W; M; P; Q; D];
end