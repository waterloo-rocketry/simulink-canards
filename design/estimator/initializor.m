function [x_init] = initializor(meas)
    % Computes inital state and covariance estimate for EKF, and bias values for the IMU
    % Uses all available sensors: Gyroscope W, Magnetometer M,
    % Accelerometer A, Barometer P and T, GPS lon, lat, alt
    
    %%% decompose measurement vector
    W = meas(1:3); M = meas(4:6); A = meas(7:9); P = meas(10);
    
    %%% load parameters
    param = load("design/model/model_params.mat");

    %%% compute quaternion attitude
    %a = S_A*A;
    %phi = atan(abs(a(3)/a(1))); % defines inital attitude on the rail, rail is pitched
    phi = deg2rad(-5); % replace with attitude determination later on
    d = [0;1;0];    
    q = [cos(phi/2); d*sin(phi/2)];

    %%% compute altitude
    g0 = 9.8; % zero height gravity
    air_R = 287.0579; % specific gas constant for air
    T_B = 288.15; % troposphere base temperature
    P_B = 101325; % troposphere base pressure
    alt = -log(P/P_B)*air_R*T_B/g0;

    %%% set inital values
    w = [0; 0; 0];
    v = [0; 0; 0];
    Cl = param.Cl_alpha;
    delta = 0;

    %%% compute earth magnetic field
    S = model_quaternion_rotmatrix(q);
    M_E = param.S_M*(S')*M;
    
    %%% save parameters
    % save("design/estimator/initial_params.mat","M_E","-append")
    
    q = [1; 0; 0; 0]; % initial attitude disturbance
    %%% conconct state vector
    x_init = [q;w;v;alt;Cl;delta];
end

