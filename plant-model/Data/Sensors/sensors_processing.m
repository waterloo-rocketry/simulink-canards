%% Notes
%%% Units are m/s^2, rad/s, Gauss, Pa
% Convert from datasheet if necessary

%%% In datasheets, noise is provided as noise density in unit/sqrt(Hz), or RMS.
% Simulink White Noise needs it as height of power spectral density, so
% input the noise value as (noise density)^2, or (RMS)^2/bandwidth = (RMS)^2*samplingrate.

%% Processor values
samplingrate = 0.01; % sampling period of the estimator

%% IMU 1 values (Movella MTi630)

imu1_accel_limit = 10*9.81;
imu1_accel_bias = 15e-6*9.81;
imu1_accel_noise = (60e-6*9.81)^2;

imu1_gyro_limit = deg2rad(2000);
imu1_gyro_bias = deg2rad(8/3600);
imu1_gyro_noise = (deg2rad(0.007))^2;

imu1_mag_limit = 8; % not yet used in Sim
imu1_mag_noise = (1e-3)^2 * samplingrate;

imu1_baro_limit = [300e2, 1250e2]; % not yet used in Sim
imu1_baro_bias = 8;
imu1_baro_noise = (1.2)^2 * samplingrate;

%% IMU 2 values (Polulu AltIMU v6: STMs LSM6DSO, LIS3MDL, LPS22DF)

imu2_accel_limit = 16*9.81;
imu2_accel_bias = 20e-3*9.81;
imu2_accel_noise = (110e-6*9.81)^2;

imu2_gyro_limit = deg2rad(2000);
imu2_gyro_bias = deg2rad(1);
imu2_gyro_noise = (deg2rad(3.8e-3))^2;

imu2_mag_limit = 16; % not yet used in Sim
imu2_mag_noise = (4.1e-3)^2 * samplingrate;

imu2_baro_limit = [260e2, 1260e2]; % not yet used in Sim
imu2_baro_bias = 9;
imu2_baro_noise = (0.0034e2)^2 * samplingrate;
