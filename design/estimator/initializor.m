function [x_init, bias, out] = initializor(meas)
    % Computes inital state and covariance estimate for EKF, and bias values for the IMU
    % Uses all available sensors: Gyroscope W, Magnetometer M, Accelerometer A, Barometer P

    persistent sensors; % remembers from last iteration

    %%% decompose measurement vector
    W = meas(1:3); M = meas(4:6); A = meas(7:9); P = meas(10);

    %%% load parameters
    S_M = eye(3);
    S_A = eye(3);
    Cl_alpha = 1.5;
    g0 = 9.8; % zero height gravity
    air_R = 287.0579; % specific gas constant for air
    T_B = 288.15; % troposphere base temperature
    P_B = 101325; % troposphere base pressure
    k_B = 0.0065; % troposphere base lapse rate

    %% Bias determination
    y = meas(1:10);
    if isempty(sensors)
        sensors = y;
    end
    %%% lowpass to attenuate sensor noise
    alpha = 0.005; % low pass time constant
    sensors = sensors + alpha*(y-sensors); % lowpass filter

    %% State determination
    %%% gravity vector in body-fixed frame
    a = S_A*sensors(7:9);

    %%% compute launch attitude quaternion
    psi = atan(-a(2)/a(1)); % rail yaw angle
    theta = atan(a(3)/a(1)); % rail pitch angle
    q = [cos(psi/2)*cos(theta/2); 
         -sin(psi/2)*sin(theta/2);
         cos(psi/2)*sin(theta/2);
         sin(psi/2)*cos(theta/2)];

    %%% compute altitude
    P = sensors(10);
    % alt = -log(P/P_B)*air_R*T_B/g0;
    alt = T_B/k_B * (1- (P/P_B)^(air_R*k_B/g0) );
    
    %%% set constant initials
    w = [0; 0; 0];
    v = [0; 0; 0];
    Cl = Cl_alpha;
    delta = 0;

    %%% conconct state vector
    x_init = [q;w;v;alt;Cl;delta];

    %% Bias output
    bias = zeros(9,1);
    
    %%% gyroscope
    bias(1:3) = sensors(1:3);
    bias(7:9) = sensors(7:9);
    
    %%% compute earth magnetic field
    S = quaternion_rotmatrix(q); % launch attitude
    M_E = (S')*(S_M')*sensors(4:6); % sensorframe -> body-fixed -> earth-flat
    bias(4:6) = M_E;

    %% troubleshooting
    out = [sensors; M_E; psi; theta];
end

