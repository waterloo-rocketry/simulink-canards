function [canard_pos_x_cp, canard_Cnalphat, canard_Cnfdelta, canard_CndNi, canard_aspectratio, canard_area, canard_midchord_angle, canard_dist_chord_mean, canard_pos_r_chord_mean, canard_leading_edge] = canards(canard_chord_root,canard_chord_tip, canard_height, canard_pos_x_roottip, canard_number, rocket_area_frontal, rocket_diameter, nosecone_radius)
rt = 0.152 / 2; % tail radius [m]
c1_canard = ((canard_chord_root+canard_chord_tip) /  2) * (rt^2) * canard_height;
c2_canard = ((canard_chord_root + 2*canard_chord_tip)/3) * rt * (canard_height^2);
c3_canard = ((canard_chord_root + 3*canard_chord_tip)/12) * (canard_height^3);
sweep_canard = (canard_chord_root - canard_chord_tip); % calculating que sweep_canard distance
canard_area = (canard_chord_root + canard_chord_tip) * canard_height / 2; % fin area
canard_aspectratio = 2 * (canard_height^2) / canard_area; % Fin Aspect Ratio
canard_midchord_angle = atan( (canard_chord_root - canard_chord_tip) / (2 * canard_height) ); % mid chord angle
canard_dist_chord_mean = (canard_chord_root + 2 * canard_chord_tip) / (canard_chord_root + canard_chord_tip); %mean aerodynamic chord distance
canard_pos_r_chord_mean = rt + (canard_height/3) * canard_dist_chord_mean; %mean aerodynamic chord distance with the radius added
canard_leading_edge = sqrt((canard_chord_root / 2 - canard_chord_tip / 2) ^ 2 + canard_height ^ 2); % Pre calculus. No Physical meaning

canard_pos_x_cp = canard_pos_x_roottip - (sweep_canard / 3) * ( (canard_chord_root + 2 * canard_chord_tip) / (canard_chord_root + canard_chord_tip) ) + (1/6) * (canard_chord_root + canard_chord_tip - canard_chord_root * canard_chord_tip / (canard_chord_root + canard_chord_tip)); % Fin's center of pressure
canard_Cnalphat = ((4 * canard_number * (canard_height / rocket_diameter) ^ 2) / (1 + sqrt(1 + (2 * canard_leading_edge / (canard_chord_root + canard_chord_tip)) ^ 2))) * (1 + rt / (canard_height + rt));
canard_Cnalphat = canard_Cnalphat * (1 + nosecone_radius/(canard_height + nosecone_radius)); %interference factor

canard_Cnfdelta = canard_number * canard_pos_r_chord_mean / canard_height; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
canard_CndNi= (canard_number * (c1_canard + c2_canard + c3_canard))/(rocket_area_frontal * (rocket_diameter)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)
end