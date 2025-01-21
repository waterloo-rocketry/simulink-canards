function [x_pos_fins, Cnfdelta, CndNi, CNa_fins, AR, Af, gamac, yparcial, Y, Lf] = fins(Cr, Ct, span, sweep, pos_aletas, rt, N_fins, Ar, Lr, r0)
%Fin-related parameters
Af = (Cr + Ct) * span / 2; % fin area
AR = 2 * (span^2) / Af; % Fin Aspect Ratio
gamac = atan( sweep / (2 * span) ); % mid chord angle
yparcial = (Cr + 2 * Ct) / (Cr + Ct); %mean aerodynamic chord distance
Y = rt + (span/3) * yparcial; %mean aerodynamic chord distance with the radius added
Lf = sqrt((sweep / 2) ^ 2 + span ^ 2); % Pre calculus. No Physical meaning

% Pre calculus for extense calculations
c1 = ((Cr + Ct) /  2) * (rt^2) * span;
c2 = ((Cr + 2*Ct)/3) * rt * (span^2);
c3 = ((Cr + 3*Ct)/12) * (span^3);

x_pos_fins = pos_aletas - (sweep / 3) * ( (Cr + 2 * Ct) / (Cr + Ct) ) + (1/6) * (Cr + Ct - Cr * Ct / (Cr + Ct)); % Fins center of pressure
Cnfdelta = N_fins * Y / span; % roll forcing moment coefficient derivative, multiple by delta and Cnalfa1
CndNi= (N_fins * (c1 + c2 + c3))/(Ar * (Lr)) ; %roll damping moment coefficient derivative (partial, uses real time numbers during simulation)
CNa_fins = ((4 * N_fins * (span / Lr) ^ 2) / (1 + sqrt(1 + (2 * Lf / (Cr + Ct)) ^ 2))) * (1 + rt / (span + rt));
CNa_fins = CNa_fins * (1 + r0/(span + r0)); %interference factor
end