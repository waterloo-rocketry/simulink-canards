function [x_new] = solver_cgrk3(f,T,step,t,x0,u)
    % Computes solution of Vector-valued IVP using a mix of Crouch-Grossman 3 and explicit Runge−Kutta 3.
    % x_new at time t+T, using step size step
    % Crouch-Grossman is used for quaternion integration, and is a Lie group geometric integration method which preserves the unit quaternion

    % Explicit Runge-Kutta-3 coefficients
    a_rk = [0, 1/2, 1]; 
    B_rk = [0, 0, 0; 
            1/2, 0, 0; 
            -1, 2, 0];
    c_rk = [1, 4, 1]/6;

    % Crouch-Grossman-3 coefficients
    a_cg = [0, 3/4, 17/24]; 
    B_cg = [0, 0, 0; 
            3/4, 0, 0; 
            119/216, 17/108, 0];
    c_cg = [13/51, 4-2/3, 24/17];


    % Preallocate the k array
    t_vec = 0:step:T;
    k = zeros(length(x0), length(a));

    % Initial value
    x_m = x0;
    
    % Main loop over time steps
    for m = 1:length(t_vec)-1

        % Compute the stages
        for n = 1:length(a)
            bk = k(:, 1:n) * B(n, 1:n)';
            k(:, n) = f( t+(m+a(n))*step , x_m+step*bk , u );


        end

        % value at time t+m*step
        x_m1 = x_m(5:end) + step * (k*c');
        q_m1 = 
        
        x_m = [q_m1; x_m1];
    end

    % Output last value at time t+T
    x_new = x_m;
end