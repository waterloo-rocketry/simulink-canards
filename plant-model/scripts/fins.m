function [pos_x_cp, Cnfdelta, CndNi, CNa, aspectratio, fin_area, midchord_angle, dist_chord_mean, pos_r_chord_mean, leading_edge] = fins(chord_root, chord_tip, fin_height, sweep, pos_x_tip, fin_number, rocket_area_frontal, rocket_diameter)
%Fin-related parameters
fin_area = (chord_root + chord_tip) * fin_height / 2; % fin area
aspectratio = 2 * (fin_height^2) / fin_area; % Fin Aspect Ratio
midchord_angle = atan2( sweep, (2 * fin_height) ); % mid chord angle
dist_chord_mean = (chord_root + 2 * chord_tip) / (chord_root + chord_tip); %mean aerodynamic chord distance
pos_r_chord_mean = rocket_diameter + (fin_height/3) * dist_chord_mean; %mean aerodynamic chord distance with the radius added
leading_edge = sqrt((sweep / 2) ^ 2 + fin_height ^ 2); % Pre calculus. No Physical meaning

% Pre calculus for extense calculations
c1 = ((chord_root + chord_tip) /  2) * (rocket_diameter^2) * fin_height;
c2 = ((chord_root + 2*chord_tip)/3) * rocket_diameter * (fin_height^2);
c3 = ((chord_root + 3*chord_tip)/12) * (fin_height^3);

pos_x_cp = pos_x_tip - (sweep / 3) * ( (chord_root + 2 * chord_tip) / (chord_root + chord_tip) ) + (1/6) * (chord_root + chord_tip - chord_root * chord_tip / (chord_root + chord_tip)); % Fins center of pressure
Cnfdelta = fin_number * pos_r_chord_mean / fin_height; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
CndNi= (fin_number * (c1 + c2 + c3))/(rocket_area_frontal * (rocket_diameter)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)
CNa = ((4 * fin_number * (fin_height / rocket_diameter) ^ 2) / (1 + sqrt(1 + (2 * leading_edge / (chord_root + chord_tip)) ^ 2))) * (1 + rocket_diameter / (fin_height + rocket_diameter));
CNa = CNa * (1 + rocket_diameter/(fin_height + rocket_diameter)); %interference factor
end