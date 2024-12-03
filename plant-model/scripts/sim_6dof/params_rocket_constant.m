%%%%%%%% Rocket Parameters %%%%%%%
%% Mass, Inertia
mf = 40;                               %final (dry) mass [kg]
Jyyf = 21;                              %final (dry) moment of inertia in pitch, yaw [kg*m2]
Jxxf = 0.135;                         %final (dry) moment of inertia in roll [kg*m2]
Jf = diag([Jxxf, Jyyf, Jyyf]);
cgf = [-1 0 0];                      %final (dry) center of gravity [m]
cs = [-0.5 0 0];                       %location of IMU  
l_R = 2.5;                             %rocket length


%% Aerodynamics
cp = [-1.7 0 0];                       %center of aerodynamic pressure (fixed) [m]
aero_length = 0.127;                    %Reference length
aero_area_front = 0.127^2*pi/4;         %Frontal area
c_aero = [0.51, 7.8, 7.8, 0, 0, 0];    %Aerodynmaic coefficients of rocket body [], [x y z rotx roty rotz]