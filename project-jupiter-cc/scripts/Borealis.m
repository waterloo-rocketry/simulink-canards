%Entrada de dados
%everything here should be metric, sanity check existing values for units scale
%Reference parameters
Lr = 127/1000; % reference length [m]
Ar = pi * (Lr^2) / 4; % reference area [m^2]
        
%Payload parameters
logiva = -558.29/1000; % payload length [m]
r0 = 127 / 2000; % payload radius [m]
Vb = 0.004253; %payload volume (why isn't this computed directly?) [m^3]?

%Body parameters
rt = 127 / 2000; % tail radius [m]
l0 = -2.528; % rocket length [m]
lTubo = l0 - logiva; % fuselage length only [m]
x_cg = -1.278; % CM location measured from payload [m]
Rs = 40/1000000; % RMC(?) roughness

%Fin parameters
Cr = 120 / 1000;
Ct = 40 / 1000;
span = 100 / 1000; %[m]
pos_aletas = -2.367; % postion of fins measured from payload
N = 4; % Number of fins
delta = degtorad(2); % fin cant angle

%Tail parameters
h = 60 / 1000; % tail length
r2 = 43.5 / 1000; % smallest tail radius(?)
pos_tail = l0; % tail position measured from payload

% Canards set 
N_canard = 4;
Cr_canard = 40 / 1000;
Ct_canard = 40 / 1000; %"The tip is the size of the root to take advantage of the fact that the further away from the rocket, the greater the moment arm."
span_canard = 80 / 1000;
arm_canard = 10/1000; % Moment arm from fin to fuselage
alfa_canard = degtorad(0); % Canard maximum angle of attack
%pos_canard = -(558.29 + 40)/1000;
pos_canard=x_cg; %assume fins are at CM - don't affect CP(?)

%Simulink data
or_data = readtable("project-jupiter-cc\Data\Borealis_flight.csv")
% mcarregado = 18.48; %wet mass
% mdescarregado = 15.576; %dry mass
% MatrizDeInercia = [0.03616 0 0; 0 8.458 0; 0 0 8.457]; %inertia matrix
% MatrizDeInerciaDescarregado = [0.034 0 0; 0 6.839 0; 0 0 6.838]; %dry inertia matrix
% F = readtable('../Data/Comercial/Pro75M3100_saida_do_trilho.csv');
% F_array = table2array(F);
% F_input = F{:, 1};
% F_data = F{:, 2};

% % Mdot
% MDot = readtable('../Data/Comercial/cesaroni_wt_mdot.csv');
% MDot_array= table2array(MDot);
% MDot_input = MDot{:, 1};
% MDot_data = MDot{:, 2};
% V_Exhaust = 1168.09;               % SOURCE: PROPULSION TR LASC 2020

% CD = readtable('../Data/Novo_CD.csv');
% CD_array = table2array(CD);
% CD_input = CD{:, 1};
% CD_data = CD{:, 2};