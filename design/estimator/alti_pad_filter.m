function [x_init, bias] = alti_pad_filter(IMU, GPS)
    % Computes inital state and covariance estimate for EKF, and bias values for the IMU
    % Uses all available sensors: Gyroscope W, Magnetometer M, Accelerometer A, Barometer P
    % Outputs: initial state, sensor bias matrix

    % filtered_i is lowpass filtered data of IMU_i
    persistent filtered; % remembers from last iteration

    %% parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end 


    %% Initialization
    if isempty(filtered)
        filtered = IMU(1:10);
    end

    %% lowpass filter
    alpha = 0.005; % low pass time constant
    % filtered = filtered + alpha*(measured-filtered);
    filtered = alpha * IMU(1:10) + (1 - alpha) * filtered;


    %% State determination
    
    %%% average specific force of selected sensors
    a = zeros(3,1); % acceleration a
    a = filtered(1:3);

    %%% gravity vector in body-fixed frame
    psi = atan(-a(2) / a(1)); % rail yaw angle
    theta = atan(a(3) / a(1)); % rail pitch angle

    %%% compute launch attitude quaternion
    q = [cos(psi/2) * cos(theta/2); 
         -sin(psi/2) * sin(theta/2);
         cos(psi/2) * sin(theta/2);
         sin(psi/2) * cos(theta/2)];

    %%% current altitude
    alt = param.elevation;
    
    %%% set constant initials
    vx = 0; % stationary on rail

    %%% conconct state vector
    x_init = [q; vx; alt];

    %% Bias determination
    
    % declare bias vectors
    bias = zeros(10, 1); 
    
    %%% accelerometer
    % did not add accelerometer bias determination yet, leave out for now

    %%% gyroscope
    bias(4:6) = filtered(4:6);
    
    %%% earth magnetic field
    ST = transpose(quaternion_rotmatrix(q)); % launch attitude  
    bias(7:9) = ST * filtered(7:9);
    % TODO: add iron corrections. Maybe in IMU handler, next to rotation correction??

    %%% barometer
    pressure = model_airdata(param.elevation).pressure; % what the pressure should be at this elevation
    bias(10) = filtered(10) - pressure;

end