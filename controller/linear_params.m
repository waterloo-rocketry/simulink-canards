%% Environment
g = 9.81;                               %gravity
rho = 1.293;                        %Density of Atmosphere [kg/m3] 
V = 20;                                 %airspeed [m/s]

%% Inertia
J = 0.5;                        %Roll Inertia

%% Actuator
tau = 1/60;                     %Time constant of 1st order actor model

%% Aerodynamics
ref_length = 0.2;               %Reference length
ref_area = 0.002;               %Reference area, surface area of canard

c_l_d = 6;                      %Lift coefficient of canard

c_l = 1;                        %Roll forcing coefficient
c_l_p = 1;                      %Roll damping coefficient