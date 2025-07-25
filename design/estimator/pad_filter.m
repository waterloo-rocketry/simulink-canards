function [x_init, bias_1, bias_2] = pad_filter(IMU_1, IMU_2, sensor_select)
    % Computes inital state and covariance estimate for EKF, and bias values for the IMU
    % Uses all available sensors: Gyroscope W, Magnetometer M, Accelerometer A, Barometer P
    % Outputs: initial state, sensor bias matrix
    %#codegen


    % filtered_i is lowpass filtered data of IMU_i
    persistent filtered_1 filtered_2; % remembers from last iteration

    %% parameters
    persistent param
    if isempty(param)
        param = coder.load("model/model_params.mat");
    end 


    %% Initialization

    if isempty(filtered_1)
        if sensor_select(1) == 1 % if IMU_i alive
            filtered_1 = IMU_1;
        else
            filtered_1 = zeros(10,1);
        end
    end
    if isempty(filtered_2)
        if sensor_select(2) == 1 % if IMU_i alive
            filtered_2 = IMU_2;
        else
            filtered_2 = zeros(10,1);
        end
    end


    %% lowpass filter

    alpha = 0.005; % low pass time constant
    % filtered = filtered + alpha*(measured-filtered);

    if sensor_select(1) == 1
        filtered_1 = alpha * IMU_1 + (1 - alpha) * filtered_1;
    end
    if sensor_select(2) == 1
        filtered_2 = alpha * IMU_2 + (1 - alpha) * filtered_2;
    end


    %% State determination
    
    %%% average specific force of selected sensors
    a = zeros(3,1); % acceleration a
    if sensor_select(1) == 1 % only add alive IMUs to average
        a = a + filtered_1(1:3);
    end
    if sensor_select(2) == 1
        a = a + filtered_2(1:3);
    end
    a = a / norm(sensor_select, 1); % divide by number of alive IMUs

    %%% gravity vector in body-fixed frame
    psi = atan2(-a(2), a(1)); % rail yaw angle
    theta = atan2(a(3), a(1)); % rail pitch angle

    %%% compute launch attitude quaternion
    q = [cos(psi/2) * cos(theta/2); 
         -sin(psi/2) * sin(theta/2);
         cos(psi/2) * sin(theta/2);
         sin(psi/2) * cos(theta/2)];

    %%% launch altitude
    alt = param.elevation;
    
    %%% set constant initials
    w = [0; 0; 0]; % stationary on rail
    v = [0; 0; 0]; % stationary on rail
    Cl = param.Cl_alpha; % from model parameters
    delta = 0; % controller sets canards to zero due to flight phase

    %%% conconct state vector
    x_init = [q; w; v; alt; Cl; delta];

    %% Bias determination
    
    % declare bias vectors
    bias_1 = zeros(10, 1); 
    bias_2 = zeros(10, 1);
    
    %%% accelerometer
    % did not add accelerometer bias determination yet, leave out for now
    if sensor_select(1) == 1
        bias_1(1:3) = filtered_1(1:3);
    end
    if sensor_select(2) == 1
        bias_2(1:3) = filtered_2(1:3);
    end

    %%% gyroscope
    if sensor_select(1) == 1
        bias_1(4:6) = filtered_1(4:6);
    end
    if sensor_select(2) == 1
        bias_2(4:6) = filtered_2(4:6);
    end
    
    %%% earth magnetic field
    ST = transpose(quaternion_rotmatrix(q)); % launch attitude
    % TODO: add iron corrections. Maybe in IMU handler, next to rotation correction??
    if sensor_select(1) == 1
        bias_1(7:9) = ST * filtered_1(7:9);
    end
    if sensor_select(2) == 1
        bias_2(7:9) = ST * filtered_2(7:9);
    end

    %%% barometer
    pressure = model_airdata(param.elevation).pressure; % what the pressure should be at this elevation
    if sensor_select(1) == 1
        bias_1(10) = filtered_1(10) - pressure;
    end
    if sensor_select(2) == 1
        bias_2(10) = filtered_2(10) - pressure;
    end

end