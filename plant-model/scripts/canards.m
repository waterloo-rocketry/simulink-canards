function [x_pos_canard,Cnalfat_canard,Cnfdelta_canard, CndNi_canard, AR_canard, Af_canard, gamac_canard, yparcial_canard, Y_canard, Lf_canard] = canards(chord_root, chord_tip, span, pos_x, N_canard, Ar, Lr)
rt = 0.152 / 2; % tail radius [m]
c1_canard = ((chord_root+chord_tip) /  2) * (rt^2) * span;
c2_canard = ((chord_root + 2*chord_tip)/3) * rt * (span^2);
c3_canard = ((chord_root + 3*chord_tip)/12) * (span^3);
sweep_canard = (chord_root - chord_tip); % calculating que sweep_canard distance
Af_canard = (chord_root + chord_tip) * span / 2; % fin area
AR_canard = 2 * (span^2) / Af_canard; % Fin Aspect Ratio
gamac_canard = atan2( (chord_root - chord_tip), (2 * span) ); % mid chord angle
yparcial_canard = (chord_root + 2 * chord_tip) / (chord_root + chord_tip); %mean aerodynamic chord distance
Y_canard = rt + (span/3) * yparcial_canard; %mean aerodynamic chord distance with the radius added
Lf_canard = sqrt((chord_root / 2 - chord_tip / 2) ^ 2 + span ^ 2); % Pre calculus. No Physical meaning

x_pos_canard = pos_x - (sweep_canard / 3) * ( (chord_root + 2 * chord_tip) / (chord_root + chord_tip) ) + (1/6) * (chord_root + chord_tip - chord_root * chord_tip / (chord_root + chord_tip)); % Fin's center of pressure
Cnalfat_canard = ((4 * N_canard * (span / Lr) ^ 2) / (1 + sqrt(1 + (2 * Lf_canard / (chord_root + chord_tip)) ^ 2))) * (1 + rt / (span + rt));
Cnalfat_canard = Cnalfat_canard * (1 + Lr/(span + Lr)); %interference factor

Cnfdelta_canard = N_canard * Y_canard / span; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
CndNi_canard= (N_canard * (c1_canard + c2_canard + c3_canard))/(Ar * (Lr)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)
end