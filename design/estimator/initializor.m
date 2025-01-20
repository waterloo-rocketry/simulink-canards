function [x_init, bias, out] = initializor(meas)
    % Computes inital state and covariance estimate for EKF, and bias values for the IMU
    % Uses all available sensors: Gyroscope W, Magnetometer M,
    % Accelerometer A, Barometer P and T, GPS lon, lat, alt

    persistent sensors; % remembers from last iteration

    %%% decompose measurement vector
    W = meas(1:3); M = meas(4:6); A = meas(7:9); P = meas(10);

    %%% load parameters
    % param = load("design/model/model_params.mat");
    S_M = eye(3);
    S_A = eye(3);
    Cl_alpha = 1.5;
    g0 = 9.8; % zero height gravity
    air_R = 287.0579; % specific gas constant for air
    T_B = 288.15; % troposphere base temperature
    P_B = 101325; % troposphere base pressure

    %% Bias determination
    y = meas(1:9);
    alpha = 0.05; % low pass time constant
    if isempty(sensors)
        sensors = y;
    end
    %%% lowpass to attenuate sensor noise
    sensors = sensors + alpha*(y-sensors);

    %% State computation
    %%% compute quaternion attitude
    a = S_A*sensors(7:9);

    psi = atan(-a(2)/a(1)); % defines inital attitude on the rail, rail is yawed
    theta = atan(a(3)/a(1)); % defines inital attitude on the rail, rail is pitched
    q = [cos(psi/2)*cos(theta/2); 
         -sin(psi/2)*sin(theta/2);
         cos(psi/2)*sin(theta/2);
         sin(psi/2)*cos(theta/2)];

    %%% compute altitude
    alt = -log(P/P_B)*air_R*T_B/g0;
    
    %%% set inital values
    w = [0; 0; 0];
    v = [0; 0; 0];
    Cl = Cl_alpha;
    delta = 0;

    %%% save parameters
    % save("design/estimator/initial_params.mat","M_E","-append")

    %%% conconct state vector
    x_init = [q;w;v;alt;Cl;delta];

    %% Bias output
    bias = zeros(6,1);
    %%% gyroscope
    bias(1:3) = sensors(1:3);

    %%% compute earth magnetic field
    S = model_quaternion_rotmatrix(q);
    M_E = (S')*(S_M')*sensors(4:6);
    bias(4:6) = M_E;
    out = [sensors; M_E; psi; theta];
end

