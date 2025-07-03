%% Winds

%%% Constant wind
wind_const_direction = deg2rad(180);
wind_const_strength = 2; % m/s

%%% discrete gusts
wind_gust1_start = 10; % s
wind_gust1_length = [120 120 80]; % m
wind_gust1_amplitude = 0.5 * [3.5 3.0 3.0] * 0; % m/s
wind_gust1_distribution = rand(3,1); % factor of gust on each axis

wind_gust2_start = 20;
wind_gust2_length = [40 30 20]; % m
wind_gust2_amplitude = 0.5 * [6 7 4] * 0; % m/s
wind_gust2_distribution = rand(3,1); % factor of gust on each axis