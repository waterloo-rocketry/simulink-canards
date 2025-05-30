function [altitude] = model_altdata(pressure)
    % computes altitude data from barometric pressure, according to US standard atmosphere 
    % calculations found in Stengel 2004, pp. 30

    % parameters
    air_gamma = 1.4; % adiabatic index
    air_R = 287.0579; % specific gas constant for air
    air_atmosphere = [0, 101325, 288.15, 0.0065; % troposphere
                      11000, 22632.1, 216.65, 0; % tropopause
                      20000, 5474.9, 216.65, -0.001; % stratosphere
                      32000, 868.02, 228.65, -0.0028]; % stratosphere 2
                      % base height, P_base, T_base, lapse rate;
    earth_r0 = 6356766; % mean earth radius
    earth_g0 = 9.81; % zero height gravity
  
    % select atmosphere behaviour from table
    layer = air_atmosphere(1,:);

    b = layer(1); % base height
    P_B = layer(2); % base pressure
    T_B = layer(3); % base temperature
    k_B = layer(4); % temperature lapse rate
    
    % compute altitude with measured pressure, but tabled temperature
    altitude = b + T_B/k_B * (1- (pressure/P_B)^(air_R*k_B/earth_g0) );

    % Geopotential altitude to normal altitude
    altitude = altitude * earth_r0 / (altitude + earth_r0);
end