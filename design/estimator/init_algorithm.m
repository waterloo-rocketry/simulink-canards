function [x_init, bias, out] = init_algorithm(meas)
    % Computes inital state and covariance estimate for EKF, and bias values for the IMU
    % Uses all available sensors: Gyroscope W, Magnetometer M, Accelerometer A, Barometer P
    % Outputs: initial state, sensor bias matrix

    persistent sensors; % remembers from last iteration
    if isempty(sensors)
        sensors = meas;
    end

    global IMU_select

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end

    g0 = 9.8; % zero height gravity
    air_R = 287.0579; % specific gas constant for air
    T_B = 288.15; % troposphere base temperature
    P_B = 101325; % troposphere base pressure
    k_B = 0.0065; % troposphere base lapse rate

    %% lowpass filter
    alpha = 0.005; % low pass time constant
    %%% lowpass to attenuate sensor noise
    sensors = sensors + alpha*(meas-sensors);

    %% decompose measurement matrix
    A = sensors(1:3,:); W = sensors(4:6,:); M = sensors(7:9,:); P = sensors(10,:);

    %% State determination
    
    %%% average specific force of selected sensors
    a = zeros(3,1);
    for i = 1:size(meas,2)
        a = a + A(:, i) /size(A,2);
    end

    %%% gravity vector in body-fixed frame
    psi = atan(-a(2)/a(1)); % rail yaw angle
    theta = atan(a(3)/a(1)); % rail pitch angle

    %%% compute launch attitude quaternion
    q = [cos(psi/2)*cos(theta/2); 
         -sin(psi/2)*sin(theta/2);
         cos(psi/2)*sin(theta/2);
         sin(psi/2)*cos(theta/2)];

    %%% compute altitude
    p = 0;
    for i = 1:size(meas,2)
        p = p + P(i) / size(meas,2);
    end
    % alt = -log(P/P_B)*air_R*T_B/g0;
    alt = T_B/k_B * (1- (p/P_B)^(air_R*k_B/g0) );
    
    %%% set constant initials
    w = [0; 0; 0];
    v = [0; 0; 0];
    Cl = param.Cl_alpha;
    delta = 0;

    %%% conconct state vector
    x_init = [q;w;v;alt;Cl;delta];

    %% Bias output
    bias = zeros(size(meas)); % prep bias matrix
    
    %%% accelerometer
    bias(1:3,:) = A;

    %%% gyroscope
    bias(4:6,:) = W;
    
    %%% earth magnetic field
    S = quaternion_rotmatrix(q); % launch attitude    
    M_E = zeros(3, norm(IMU_select, 1));
    for i = 1:size(meas,2)
        M_E(:,i) = (S')*M(:, i); % sensorframe -> body-fixed -> earth-flat
        % TODO: add iron corrections
    end
    bias(7:9, :) = M_E;

    %%% barometer
    bias(10,:) = P;

    %% troubleshooting
    out = [sensors; M_E; psi; theta];
end

