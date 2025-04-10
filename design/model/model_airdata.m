function [pressure, density, mach] = model_airdata(altitude)
    % computes air data from altitude, according to US standard atmosphere 
    % air data: static pressure, temperature, density, local speed of sound
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

    % geopotential altitude
    altitude = earth_r0*altitude / (earth_r0 -altitude);
    
    % select atmosphere behaviour from table
    layer = air_atmosphere(1,:);
    if altitude > air_atmosphere(2,1)
        if altitude < air_atmosphere(3,1)
            layer = air_atmosphere(2,:);
        elseif altitude < air_atmosphere(4,1)
            layer = air_atmosphere(3,:);
        elseif altitude >= air_atmosphere(4,1)
            layer = air_atmosphere(4,:);
        end
    end

    b = layer(1); % base height
    P_B = layer(2); % base pressure
    T_B = layer(3); % base temperature
    k = layer(4); % temperature lapse rate
    
    if k == 0
        pressure = P_B * exp(-earth_g0*(altitude-b)/(air_R*T_B));
    else
        pressure = P_B * (1 - k/T_B*(altitude-b))^(earth_g0/(air_R*k));
    end
    temperature = T_B - k*(altitude-b);
    density = pressure / (air_R*temperature);
    mach = sqrt(air_gamma*air_R*temperature);
end