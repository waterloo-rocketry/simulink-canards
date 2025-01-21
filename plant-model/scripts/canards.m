function [x_pos_canard,Cnalfat_canard,Cnfdelta_canard, CndNi_canard, AR_canard] = canards(Cr,Ct, span, Cr_canard, Ct_canard, span_canard, pos_canard, N_canard, Ar, Lr, r0)
rt = 0.152 / 2; % tail radius [m]
c1_canard = ((Cr+Ct) /  2) * (rt^2) * span;
c2_canard = ((Cr + 2*Ct)/3) * rt * (span^2);
c3_canard = ((Cr + 3*Ct)/12) * (span^3);
sweep_canard = (Cr_canard - Ct_canard); % calculating que sweep_canard distance
Af_canard = (Cr_canard + Ct_canard) * span_canard / 2; % fin area
AR_canard = 2 * (span_canard^2) / Af_canard; % Fin Aspect Ratio
gamac_canard = atan( (Cr_canard - Ct_canard) / (2 * span_canard) ); % mid chord angle
yparcial_canard = (Cr_canard + 2 * Ct_canard) / (Cr_canard + Ct_canard); %mean aerodynamic chord distance
Y_canard = rt + (span_canard/3) * yparcial_canard; %mean aerodynamic chord distance with the radius added
Lf_canard = sqrt((Cr_canard / 2 - Ct_canard / 2) ^ 2 + span_canard ^ 2); % Pre calculus. No Physical meaning

x_pos_canard = pos_canard - (sweep_canard / 3) * ( (Cr_canard + 2 * Ct_canard) / (Cr_canard + Ct_canard) ) + (1/6) * (Cr_canard + Ct_canard - Cr_canard * Ct_canard / (Cr_canard + Ct_canard)); % Fin's center of pressure
Cnalfat_canard = ((4 * N_canard * (span_canard / Lr) ^ 2) / (1 + sqrt(1 + (2 * Lf_canard / (Cr_canard + Ct_canard)) ^ 2))) * (1 + rt / (span_canard + rt));
Cnalfat_canard = Cnalfat_canard * (1 + r0/(span_canard + r0)); %interference factor

Cnfdelta_canard = N_canard * Y_canard / span_canard; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
CndNi_canard= (N_canard * (c1_canard + c2_canard + c3_canard))/(Ar * (Lr)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)
end