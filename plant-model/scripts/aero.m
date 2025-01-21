% Nose
% CNa_nosecone = 2 * pi * (r0^2) / Ar;
x_pos_nosecone = -(logiva - logiva/2); % Nosecone center of pressure

% Body
% CNa_body = 2 * 1.1 * lTubo * Lr / Ar; %derivative of eq. 3.26 wrt alpha (making the substitution sin^2(a) = a^2)
x_pos_bodytube = 0 - logiva - lTubo/2; % Fuselage center of pressure

% Fins
[x_pos_fins, Cnfdelta, CndNi, CNa_fins, AR, Af, gamac, yparcial, Y, Lf] = fins(Cr, Ct, span, sweep, pos_aletas, rt, N_fins, Ar, Lr, r0);

% Tail
% CNa_tail= -2 * (1 - ((r2 / rt)^2));
r=rt/r2;
x_pos_tail = pos_tail - (h/3) * (1 + ( (1 - r) / (1 - r^2) ) );

% Canards
[x_pos_canard, CNa_canard, Cnfdelta_canard, CndNi_canard, AR_canard] = canards(Cr,Ct, span, Cr_canard, Ct_canard, span_canard, pos_canard, N_canard, Ar, Lr, r0);

% TEMP Cnalfa overrides
CNa_nosecone = 2;
CNa_body = 0;
CNa_fins = 9.6;
CNa_tail = -0.319;
CNa_canard = 0;

% reference computations (used to check internal computation against OR net values only)
Cnalfa_ref = (CNa_nosecone + CNa_fins + CNa_tail + CNa_body + CNa_canard); % Total normal force derivative
x_ref = (x_pos_nosecone * CNa_nosecone + x_pos_fins * CNa_fins + ...
    x_pos_tail * CNa_tail + CNa_body * x_pos_bodytube) / Cnalfa_ref; % total CoP as weighted average of component CPs

save("barrowman.mat")