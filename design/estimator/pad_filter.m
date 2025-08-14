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

    alpha = 0.0005; % low pass time constant
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
    A = a / norm(a); % unit vector of gravity direction
    
    %%% determine initial orientation quaternion
    qw = sqrt( 0.5 + 0.5*A(1) );
    qx = 0;
    if qw == 0 % exact upside down case
        qy = 1; % either qy = 1 or qz = 1, this is arbitrary 
        qz = 0;
    else 
        qy = 0.5 * A(3) / qw;
        qz = -0.5 * A(2) / qw;
    end
    q = [qw; qx; qy; qz];
    q = q / norm(q);

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
    if sensor_select(1) == 1
        bias_1(7:9) = ST * filtered_1(7:9);
    end
    if sensor_select(2) == 1
        bias_2(7:9) = ST * filtered_2(7:9);
    end

    %%% barometer
    pressure = model_airdata(param.elevation).pressure; % what the pressure should be at launch elevation
    if sensor_select(1) == 1
        bias_1(10) = filtered_1(10) - pressure;
    end
    if sensor_select(2) == 1
        bias_2(10) = filtered_2(10) - pressure;
    end

end