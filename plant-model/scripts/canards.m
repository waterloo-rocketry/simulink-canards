function [pos_x_cp,Cnalfat,Cnfdelta, CndNi, aspectratio, canard_area, midchord_angle, dist_chord_mean, pos_r_chord_mean, leading_edge] = canards(chord_root, chord_tip, canard_height, pos_x, canard_number, rocket_area_frontal, rocket_diameter)
rocket_radius = rocket_diameter / 2; % tail radius [m]
c1_canard = ((chord_root+chord_tip) /  2) * (rocket_radius^2) * canard_height;
c2_canard = ((chord_root + 2*chord_tip)/3) * rocket_radius * (canard_height^2);
c3_canard = ((chord_root + 3*chord_tip)/12) * (canard_height^3);
sweep_canard = (chord_root - chord_tip); % calculating que sweep_canard distance
canard_area = (chord_root + chord_tip) * canard_height / 2; % fin area
aspectratio = 2 * (canard_height^2) / canard_area; % Fin Aspect Ratio
midchord_angle = atan2( (chord_root - chord_tip), (2 * canard_height) ); % mid chord angle
dist_chord_mean = (chord_root + 2 * chord_tip) / (chord_root + chord_tip); %mean aerodynamic chord distance
pos_r_chord_mean = rocket_radius + (canard_height/3) * dist_chord_mean; %mean aerodynamic chord distance with the radius added
leading_edge = sqrt((chord_root / 2 - chord_tip / 2) ^ 2 + canard_height ^ 2); % Pre calculus. No Physical meaning

pos_x_cp = pos_x - (sweep_canard / 3) * ( (chord_root + 2 * chord_tip) / (chord_root + chord_tip) ) + (1/6) * (chord_root + chord_tip - chord_root * chord_tip / (chord_root + chord_tip)); % Fin's center of pressure
Cnalfat = ((4 * canard_number * (canard_height / rocket_diameter) ^ 2) / (1 + sqrt(1 + (2 * leading_edge / (chord_root + chord_tip)) ^ 2))) * (1 + rocket_radius / (canard_height + rocket_radius));
Cnalfat = Cnalfat * (1 + rocket_diameter/(canard_height + rocket_diameter)); %interference factor

Cnfdelta = canard_number * pos_r_chord_mean / canard_height; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
CndNi= (canard_number * (c1_canard + c2_canard + c3_canard))/(rocket_area_frontal * (rocket_diameter)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)
end