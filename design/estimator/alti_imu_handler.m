function [IMU] = alti_imu_handler(IMU)
    % Selects IMUs and rearanges IMU struct to vectors
    % Rotates IMU frame to body frame
    
    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end

    %% selector loop
    IMU_id = 2; % which IMU to use
    for k = 1:2
        % rotate into body coordinates from sensor coordinate
        IMU( 1+3*(k-1) : 3*k ) = param.S_k(:,:,IMU_id) * IMU( 1+3*(k-1) : 3*k );
    end
end