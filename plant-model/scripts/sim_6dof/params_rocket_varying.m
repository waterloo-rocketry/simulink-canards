%%%%% Curves %%%%%
%time
time_curves = 0:0.5:10;

% Thrust
isp = 10;                               % specific impulse, [s], approx const, T = isp*g*mdot
t_burn = 6.5;                           %duration of average thrust [s]
t_water = 5.2;                          %duration of water phase
T = 150;                                %Thrust [N] Invariant, to be changed to curve

% Mass
cg = (cgf+cgw)/2;                       %center of gravity
m = mf + mprop/2;                       %current mass
mdot = -mprop/t_burn;                   %mass flow [kg/s] Only if mass flow invariant, to be updated with thrust and mass curves

% Inertia
J = Jf + (Jw-Jf)/2;                     %current moment of inertia
Jxx = Jxxf + (Jxxw-Jxxf)/2;             %current moment of inertia in roll

% Airspeed 
V = 30;                                %airspeed
V_samples = [0 12 24 36 51 71 75 85 85 82 80 75 70 64 57 52 45 40 35 30 23];    %velocity [m/s] in 0.5s steps

%%%%% Calculations %%%%%
lt = ct(1)-cg(1);                             %control moment arm
lp = cp(1)-cg(1);                             %aero moment arm
ls = cs(1)-cg(1);                             %distance to sensor