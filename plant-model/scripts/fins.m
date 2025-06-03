function [fin_pos_x_cp, fin_Cnfdelta, fin_CndNi, fin_CNa, fin_aspectratio, fin_area, fin_midchord_angle, fin_dist_chord_mean, fin_pos_r_chord_mean, fin_leading_edge] = fins(fin_chord_root, fin_chord_tip, fin_height, fin_sweep, fin_pos_x_roottip, tail_radius_outer, fin_number, rocket_area_frontal, rocket_length, nosecone_radius)
%Fin-related parameters
fin_area = (fin_chord_root + fin_chord_tip) * fin_height / 2; % fin area
fin_aspectratio = 2 * (fin_height^2) / fin_area; % Fin Aspect Ratio
fin_midchord_angle = atan( fin_sweep / (2 * fin_height) ); % mid chord angle
fin_dist_chord_mean = (fin_chord_root + 2 * fin_chord_tip) / (fin_chord_root + fin_chord_tip); %mean aerodynamic chord distance
fin_pos_r_chord_mean = tail_radius_outer + (fin_height/3) * fin_dist_chord_mean; %mean aerodynamic chord distance with the radius added
fin_leading_edge = sqrt((fin_sweep / 2) ^ 2 + fin_height ^ 2); % Pre calculus. No Physical meaning

% Pre calculus for extense calculations
c1 = ((fin_chord_root + fin_chord_tip) /  2) * (tail_radius_outer^2) * fin_height;
c2 = ((fin_chord_root + 2*fin_chord_tip)/3) * tail_radius_outer * (fin_height^2);
c3 = ((fin_chord_root + 3*fin_chord_tip)/12) * (fin_height^3);

fin_pos_x_cp = fin_pos_x_roottip - (fin_sweep / 3) * ( (fin_chord_root + 2 * fin_chord_tip) / (fin_chord_root + fin_chord_tip) ) + (1/6) * (fin_chord_root + fin_chord_tip - fin_chord_root * fin_chord_tip / (fin_chord_root + fin_chord_tip)); % Fins center of pressure
fin_Cnfdelta = fin_number * fin_pos_r_chord_mean / fin_height; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
fin_CndNi= (fin_number * (c1 + c2 + c3))/(rocket_area_frontal * (rocket_length)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)
fin_Cna_0 = ((4 * fin_number * (fin_height / rocket_length) ^ 2) / (1 + sqrt(1 + (2 * fin_leading_edge / (fin_chord_root + fin_chord_tip)) ^ 2))) * (1 + tail_radius_outer / (fin_height + tail_radius_outer));
fin_CNa = fin_Cna_0 * (1 + nosecone_radius/(fin_height + nosecone_radius)); %interference factor
end