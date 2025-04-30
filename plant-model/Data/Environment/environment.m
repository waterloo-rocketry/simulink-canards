%% Winds
%%% enable
wind_dist_enable = 1; % no disturbances is = 0

%%% Constant wind
wind_const_direction = deg2rad(45);
wind_const_strength = 10; % m/s

%%% pink noise 
wind_noise_amplitude = 10; % m/s RMS
wind_noise_bandwidth = 0.5; % s

%%% discrete gusts
wind_gust1_start = 10; % s
wind_gust1_length = [120 120 80]; % m
wind_gust1_amplitude = [3.5 3.0 3.0]; % m/s
% wind_gust1_distribution = [0.5, 0.3, 0.5]; % factor of gust on each axis

wind_gust2_start = 20;
wind_gust2_length = [40 30 20]; % m
wind_gust2_amplitude = [6 7 4]; % m/s
% wind_gust2_distribution = [0.3, 0.6, 0.2]; % factor of gust on each axis