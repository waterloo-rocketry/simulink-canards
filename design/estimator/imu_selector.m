function [meas, y, u] = imu_selector(IMU, IMU_select)
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

    %%% need empty array to use end operator
    empty1 = zeros(norm(IMU_select,1),1);
    empty3 = zeros(3*norm(IMU_select,1),1);
    meas = zeros(10, norm(IMU_select,1)); 
    accel = empty3;
    omega = empty3;
    mag = empty3;
    baro = empty1;
    k = 0;

    for i = 1:length(IMU_select)
        if IMU_select(i) == 1
            %%% select sensor
            switch i
                case 1 
                    sensor = IMU.IMU1;
                case 2 
                    sensor = IMU.IMU1;
                case 3 
                    sensor = IMU.IMU3;
                otherwise 
                    sensor = zeros(10,1);
            end

            %%% rotate into body coordinates from sensor coordinates
            Sk = param.S_k(:, 3*(i-1)+1 : 3*i);
            sensor(1:3) = Sk*sensor(1:3);
            sensor(4:6) = Sk*sensor(4:6);
            sensor(7:9) = Sk*sensor(7:9);

            %%% fill meas matrix, columns are the IMU vectors
            k = k+1;
            meas(:, k) = sensor;
            %%% append vectors with IMUi
            accel(3*(k-1)+1 : 3*k, :) = sensor(1:3);
            omega(3*(k-1)+1 : 3*k, :) = sensor(4:6);
            mag(3*(k-1)+1 : 3*k, :) = sensor(7:9);
            baro(k, :) = sensor(10);
        end
    end

    y = [omega; mag; baro];
    u = [accel];
end