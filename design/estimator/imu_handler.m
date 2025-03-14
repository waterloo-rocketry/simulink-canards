function [IMU_1, IMU_2, IMU_3] = imu_handler(IMU_1, IMU_2, IMU_3, IMU_select)
    % Selects IMUs and rearanges IMU struct to vectors
    % Rotates IMU frame to body frame
    % IMU_select is vector containing zeros at indexes of dead IMUs
    % Example: IMU_select = [1, 0, 1]; selects IMU1 and IMU3
    
    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end

    %% selector loop
    for i = 1:length(IMU_select)
        if IMU_select(i) == 1
            %%% select sensor
            sensor = zeros(10,1);
            switch i
                case 1 
                    sensor = IMU_1(1:9);
                case 2 
                    sensor = IMU_2(1:9);
                case 3 
                    sensor = IMU_3(1:9);
                otherwise 
                    warning('Only 3 IMUs are coded, please enter IMU_select as a 3d vector')
                    % break; in C, I guess?
            end

            %%% rotate into body coordinates from sensor coordinates
            Sk = param.S_k(:,:,i);
            sensor(1:3) = Sk * sensor(1:3);
            sensor(4:6) = Sk * sensor(4:6);
            sensor(7:9) = Sk * sensor(7:9);

            %%% fill IMU_i structs
           switch i
                case 1 
                    IMU_1(1:9) = sensor;
                case 2 
                    IMU_2(1:9) = sensor;
                case 3 
                    IMU_3(1:9) = sensor;
                otherwise 
                    warning('Only 3 IMUs are coded, please enter IMU_select as a 3d vector')
                    % break; in C, I guess?
            end

	    end
    end
end