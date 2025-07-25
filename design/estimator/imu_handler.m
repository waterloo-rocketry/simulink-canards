function [IMU_1, IMU_2] = imu_handler(IMU_1, IMU_2, sensor_select)
    % Selects IMUs and rearanges IMU struct to vectors
    % Rotates IMU frame to body frame
    % IMU_select is vector containing zeros at indexes of dead IMUs
    % Example: IMU_select = [1, 0, 1]; selects IMU1 and IMU3
    %#codegen
    
    %% load parameters
    persistent param
    if isempty(param)
        param = coder.load("model/model_params.mat");
    end

    %% selector loop
    for k = 1:3
        if sensor_select(1) == 1 % use only alive IMUs
            % rotate into body coordinates from sensor coordinate
            IMU_1( 3*k-2 : 3*k ) = param.S1 * IMU_1( 3*k-2 : 3*k );
        end
        if sensor_select(2) == 1
            IMU_2( 3*k-2 : 3*k ) = param.S2 * IMU_2( 3*k-2 : 3*k );
        end
    end
end