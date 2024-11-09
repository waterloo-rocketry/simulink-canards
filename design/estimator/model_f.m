function [x_dot] = model_f(x, u)
    % state vector: [q(4); w(3); v(3); alt; Cl; delta]
    q = x(1:4); w = x(5:7); v = x(8:10); alt = x(11); Cl = x(12); delta = x(13);

    % rotational matrix
    S = quaternion_rotmatrix(q);

    % get parameters
    model_params
    
    % calculate air data
    p_stat = 
    temperature = init[1] - init[2] * (alt - init[3])
    rho = (pressure(h)*mol)/(gas_const*temperature);
    mach_local = math.sqrt((gamma*R*temperature(h))/mol);
    p_dyn = rho/2*norm(v)^2;

    % forces
    ...
    force = inv(S)*[-G,0,0]';   

    % torques
    torque_x = q
       
    % quaternion derivatives
    q_dot = quaternion_deriv(q, w);

    % rate derivatives
    w_dot = inv(J)*(torque - cross(w, J*w));

    % velocity derivatives 
    v_dot = force/m - cross(w,v); 

    % altitude
    pos_dot = S*v
    alt_dot = pos_dot(1);

    % canard coefficients, airfoil theory
    Cl_dot = 0; % derivation of CL_alpha_c with Ma = Ma(t)
    
    % actuator dynamics
    delta_dot = -1/tau * delta + 1/tau * u;

    x_dot = [q_dot; w_dot; v_dot; alt_dot; Cl_dot; delta_dot];
end


function [q_dot] = quaternion_deriv(q_un, w)
    % norm quaternions
    q = 1/norm(q_un) * q_un;

    % angular rate matrix
    w_tilde = [0, -w(3), w(2);
               w(3), 0, -w(1);
              -w(2), w(1), 0];
    W = [0, -w';
         w, -w_tilde];

    % quaternion derivative
    q_dot = (0.5* W * q) + norm(w)*(q-q_un);
end

function [S] = quaternion_rotmatrix(q)
    q_tilde = [0, -q(3+1), q(2+1);
               q(3+1), 0, -q(1+1);
              -q(2+1), q(1+1), 0];
    S = eye(3) + 2*q(0+1)*q_tilde + 2*q_tilde*q_tilde;
end

function [p_static] = pressure(alt)
    def set_initials(h):
    init = [] #P0,T0,L,base
    if(0<=h<11000):
        init.append(101325)
        init.append(288.15)
        init.append(0.0065)
        init.append(0)
    if(11000<=h<20000):
        init.append(22632.064)
        init.append(216.65)
        init.append(0)
        init.append(11000)
    if(20000<=h<32000):
        init.append(5474.88867)
        init.append(216.65)
        init.append(-0.001)
        init.append(20000)
    
    init = set_initials(h)
    P0 = init[0]
    T0 = init[1]
    L = init[2]
    b = init[3]
    H = geopotential_height(h)
    if(L != 0):
        P = P0 * ((1-((L*(H-b))/T0))**((gravity(h)*mol)/(R*L)))
    if(L == 0):
        P = P0 * np.exp((-mol*gravity(h)*(H-b))/(R*T0))
end