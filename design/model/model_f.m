function [x_dot] = model_f(t, x, u) % time t is not used yet, but required by matlab ode syntax
    % Computes state derivative with predictive model. Use ODE solver to compute next state.
    
    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose input vector: [delta_u(1), A(3)]
    delta_u = u(1); A = u(2:4);

    %% get parameters
    % k = load("design/model/model_params.mat");
            %%% Rocket body
            m = 40; %mass in kg
            Jx = 0.225; % inertia roll
            Jy = 52; % inertia pitch, yaw
            J = diag([Jx, Jy, Jy]);
            
            length_cp = -0.5; % center of pressure
            area_reference = pi*(8*0.0254/2)^2; % cross section of body tube
            Cn_alpha = 5; % pitch coefficent 
            
            %%% Sensors
            S_A = eye(3); % rotation transform from sensor frame to body frame
            length_cs = [0; 0; 0]; % center of sensor frame
            
            %%% Canards, Actuator
            tau = 1/25; % time constant of first order actuator dynamics
            Cl_alpha = 1.5; % estimated coefficient of lift, const with Ma
            tau_cl_alpha = 2; % time constant to converge Cl back to 1.5 in filter
            area_canard = 0.004; % total canard area 
            length_canard = 8/2*0.0254+0.05; % lever arm of canard to x-axis 
            c_canard = area_canard*length_canard; % moment arm * area of canard
            
            %%% Environment
            g = [-9.81; 0; 0]; % gravitational acceleration in the geographic inertial frame

    %% compute rotation matrix 
    %%% attitude transformation, inertial to body frame
    S = quaternion_rotmatrix(q);

    %% air data
    [~, ~, rho, ~] = model_airdata(alt);
    % airspeed = norm(v);
    % p_dyn = rho/2*airspeed^2;
    %%% angle of attack / sideslip
    % if norm(v(1)) >= 0 
    %     alpha = atan(v(3)/v(1));
    %     beta = atan(v(2)/v(1));
    % elseif norm(v(1)) <= 0
    %     alpha = pi - atan(v(3)/v(1));
    %     beta = pi - atan(v(2)/v(1));
    % else
    %     alpha = sign(v(3))*pi/2; 
    %     beta = sign(v(2))*pi/2;
    % end

    %% forces and moments

    %%% forces (specific)
    %%% comment out if using accelerometer, not needed then
    % force_aero = zeros(3,1);
    % force = force_aero / k.m;  

    %%% torques
    % torque_canards = Cl * area_canard*length_canard * 0.5*rho*v(1)*abs(v(1)) * delta *[1;0;0];
    torque_aero = Cn_alpha*area_reference*length_cp * 0.5*rho* abs([0; v(3); v(2)]')*[0; v(3); v(2)];
    torque = torque_aero;% + torque_canards;
    % torque = [0;0;0];

    %% derivatives

    % quaternion derivatives
    q_dot = quaternion_deriv(q, w);

    % rate derivatives
    w_dot = inv(J)*(torque - cross(w, J*w));
    
    % velocity derivatives 
    %%% acceleration specific force
    a = S_A*A - cross(w, cross(w, length_cs));% - cross(w_dot, length_cs);
    %%% use aerodynamic for simulation, acceleration for filter
    % v_dot = force - cross(w,v) + S*g;
    % g_body = quaternion_rotate(q, g);
    g_body = (S)*g;
    v_dot = a - cross(w,v) + g_body;

    % altitude derivative
    % [~, v_earth] = quaternion_rotate(q, v);
    v_earth = (S')*v;
    pos_dot = v_earth;
    alt_dot = pos_dot(1);

    % canard coefficients derivative
    %%% returns Cl to expected value slowly, to force convergence in EKF
    Cl_dot = -1/tau_cl_alpha * (Cl - Cl_alpha); 
    
    % actuator dynamics
    %%% linear 1st order
    delta_dot = -1/tau * (delta - delta_u);
    
    %% concoct state derivative vector
    x_dot = [q_dot; w_dot; v_dot; alt_dot; Cl_dot; delta_dot];
end
