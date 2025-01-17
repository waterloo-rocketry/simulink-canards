function [p_static, temperature, rho, mach_local] = model_airdata(alt)
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
    air_r0 = 6356766; % mean earth radius
    g0 = 9.8; % zero height gravity

    % geopotential altitude
    alt = air_r0*alt / (air_r0 -alt);
    
    % select atmosphere behaviour from table
    layer = air_atmosphere(1,:);
    if alt > air_atmosphere(2,1)
        if alt < air_atmosphere(3,1)
            layer = air_atmosphere(2,:);
        elseif alt < air_atmosphere(4,1)
            layer = air_atmosphere(3,:);
        elseif alt >= air_atmosphere(4,1)
            layer = air_atmosphere(4,:);
        end
    end

    b = layer(1); % base height
    P_B = layer(2); % base pressure
    T_B = layer(3); % base temperature
    k = layer(4); % temperature lapse rate
    
    temperature = T_B - k*(alt-b);
    if k == 0
        p_static = P_B * exp(-g0*(alt-b)/(air_R*T_B));
    else
        p_static = P_B * (1 - k/T_B*(alt-b))^(g0/(air_R*k));
    end
    rho = p_static / (air_R*temperature);
    mach_local = sqrt(air_gamma*air_R*temperature);
end