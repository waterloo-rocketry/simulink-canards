function [area_planform, area_bow, area_aft, volume, x_cp] = aerobody(length, diameter_bow, diameter_aft, pos_x_bow)
    % calculates geometry and centre of pressure for axially symmetric 
    % components. Requires all components to be frustums.

    % Geometry
    area_planform = length * (diameter_bow + diameter_aft) / 2;
    area_bow = pi * diameter_bow^2 / 4;
    area_aft = pi * diameter_aft^2 / 4;
    volume = length * (area_bow + area_aft + sqrt(area_bow * area_aft)) / 3;

    % Centre of pressure
    if area_bow == area_aft
        %cylinder
        x_cp = pos_x_bow - length / 2;
    else
        x_cp = pos_x_bow - (length * area_aft - volume) / (area_aft - area_bow);
    end
end