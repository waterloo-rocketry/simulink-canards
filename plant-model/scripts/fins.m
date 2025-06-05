function [fin_pos_x_cp, Cnfdelta, CndNi, fin_CNa, fin_aspectratio, fin_area, fin_midchord_angle, fin_dist_chord_mean, fin_pos_r_chord_mean, fin_leading_edge] = fins(Cr, Ct, fin_height, sweep, pos_aletas, fin_number, Ar, Lr)
%Fin-related parameters
fin_area = (Cr + Ct) * fin_height / 2; % fin area
fin_aspectratio = 2 * (fin_height^2) / fin_area; % Fin Aspect Ratio
fin_midchord_angle = atan( sweep / (2 * fin_height) ); % mid chord angle
fin_dist_chord_mean = (Cr + 2 * Ct) / (Cr + Ct); %mean aerodynamic chord distance
fin_pos_r_chord_mean = Lr + (fin_height/3) * fin_dist_chord_mean; %mean aerodynamic chord distance with the radius added
fin_leading_edge = sqrt((sweep / 2) ^ 2 + fin_height ^ 2); % Pre calculus. No Physical meaning

% Pre calculus for extense calculations
c1 = ((Cr + Ct) /  2) * (Lr^2) * fin_height;
c2 = ((Cr + 2*Ct)/3) * Lr * (fin_height^2);
c3 = ((Cr + 3*Ct)/12) * (fin_height^3);

fin_pos_x_cp = pos_aletas - (sweep / 3) * ( (Cr + 2 * Ct) / (Cr + Ct) ) + (1/6) * (Cr + Ct - Cr * Ct / (Cr + Ct)); % Fins center of pressure
Cnfdelta = fin_number * fin_pos_r_chord_mean / fin_height; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
CndNi= (fin_number * (c1 + c2 + c3))/(Ar * (Lr)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)
fin_CNa = ((4 * fin_number * (fin_height / Lr) ^ 2) / (1 + sqrt(1 + (2 * fin_leading_edge / (Cr + Ct)) ^ 2))) * (1 + Lr / (fin_height + Lr));
fin_CNa = fin_CNa * (1 + Lr/(fin_height + Lr)); %interference factor
end