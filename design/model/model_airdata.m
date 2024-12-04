function [p_static, temperature, rho, mach_local] = model_airdata(alt)
    % computes air data from altitude, according to US standard atmosphere 
    % air data: static pressure, temperature, density, local speed of sound
    % calculations found in Stengel 2004, pp. 30
    % geopotential altitude neglected, may (should) be added in

    % get parameters
    model_params

    % select atmosphere behaviour from table
    if alt < air_atmosphere(2,end)
        layer = air_atmosphere(1,:);
    elseif alt < air_atmosphere(3,end)
        layer = air_atmosphere(2,:);
    elseif alt < air_atmosphere(4,end)
        layer = air_atmosphere(3,:);
    elseif alt >= air_atmosphere(4,end)
        layer = air_atmosphere(4,:);
    end

    g = norm(g);
    P_B = layer(1); % base pressure
    T_B = layer(2); % base temperature
    k = layer(3); % temperature lapse rate
    b = layer(4); % base height
    
    temperature = T_B - k*(alt-b);
    if k == 0
        p_static = P_B * exp(-g*(alt-b)/(air_R*T_B));
    else
        p_static = P_B * (T_B / (T_B + k*(alt-b)))^(g/(air_R*k));
    end
    rho = p_static / (air_R*temperature);
    mach_local = sqrt(air_gamma*air_R*temperature);
end