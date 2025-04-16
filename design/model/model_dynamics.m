function [x_new] = model_dynamics(dt, x, u)
    % Computes state derivative with predictive model. Use ODE solver to compute next state.
    
    %% decomp
    % decompose state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % decompose input vector
    delta_u = u.cmd; a = u.accel;

    %% load parameters
    persistent param
    if isempty(param)
        param = load("model\model_params.mat");
    end
    
    %% compute rotation matrix 
    %%% attitude transformation, inertial to body frame
    S = quaternion_rotmatrix(q);

    %% airdata 
    airdata = model_airdata(alt);

    %% forces and torques
    torque = aerodynamics(w, v, airdata, Cl, delta, param);
    
    %% time updates

    % quaternion update
    q_new = quaternion_update(q, w, dt);
    % q_new = q + dt * quaternion_derivative(q, w);
    % q_new = q_new / norm(q_new);

    % rate update
    w_new = w + dt * param.Jinv * (torque - cross(w, param.J*w));
    
    % velocity update 
    %%% acceleration specific force    
    v_new = v + dt * (a - cross(w,v) + S*param.g);

    % altitude update
    v_earth = (S')*v;
    alt_new = alt + dt * v_earth(1);

    % canard coefficients derivative
    %%% returns Cl to expected value slowly, to force convergence in EKF
    Cl_theory = airfoil(norm(v), airdata.mach, param);
    Cl_new = Cl + dt * (1/param.tau_cl_alpha * (Cl_theory - Cl)); 
    
    % actuator dynamics
    %%% linear 1st order
    delta_new = delta + dt * (1/param.tau * (delta_u - delta));
    
    %% concoct state derivative vector
    x_new = [q_new; w_new; v_new; alt_new; Cl_new; delta_new];
end


%% aerodynamics
function [torque] = aerodynamics(w, v, airdata, Cl, delta, param)
    %%% air data
    p_dyn = airdata.density / 2 * norm(v)^2;

    %%% angle of attack/sideslip
    if v(1) >= 0.5
        sin_alpha = v(3)/v(1);
        sin_beta =  - v(2)/v(1);
    else
        sin_alpha = pi/2; 
        sin_beta = -pi/2;
    end

    %%% torques
    torque_canards = Cl *  delta * param.c_canard * p_dyn *[1;0;0];
    torque_aero = p_dyn * ( param.c_aero * param.Cn_alpha * [0; sin_alpha; sin_beta] ); 
            %+ param.Cn_omega*[0; w(2); w(3)] ) * param.c_aero; % commented
            % out because timeline
    torque = torque_canards + torque_aero;
    % torque = [0;0;0]; 
end

function [Cl_theory] = airfoil(airspeed, sonic_speed, param)
    mach_num = airspeed / sonic_speed;

    if mach_num <= 1
        Cl_theory = param.Cl_alpha;
    else
        cone = acos(1 / mach_num);
        if cone > param.canard_sweep
            Cl_theory = 4 / sqrt(mach_num^2 - 1);
        else
            m = param.canard_sweep_cot/cot(cone);
            a = m*(0.38+2.26*m-0.86*m^2);
            Cl_theory = 2*pi^2*param.canard_sweep_cot / (pi + a);
        end
    end
end