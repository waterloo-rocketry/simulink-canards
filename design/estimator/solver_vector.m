function [x_new] = solver_vector(f,T,step,t,x0,u)
    % Computes solution of Vector-valued IVP using an explicit Runge−Kutta method.
    % x_new at time t+T, using step size step
    % RK4n method, with normalization of Quaternions x(1:4) in every time step

    % Explicit Runge-Kutta-4 coefficients
    a = [0, 1, 1, 2]/2; 
    B = [0, 0, 0, 0; 
         1, 0, 0, 0; 
         0, 1, 0, 0; 
         0, 0, 1, 0]/2;
    c = [1, 2, 2, 1]/6;

    % Preallocate the k array
    t_vec = 0:step:T;
    k = zeros(length(x0), length(a));
    %y = zeros(length(x0), length(t_vec));

    % Initial value
    x_m = x0;
    %y(:,1) = x0;
    
    % Main loop over time steps
    for m = 1:length(t_vec)-1
        % Compute the stages
        for n = 1:length(a)
            bk = k(:, 1:n) * B(n, 1:n)';
            k(:, n) = f( t+(m+a(n))*step , x_m+step*bk , u );
        end
        % value at time t+m*step
        x_m1 = x_m + step * (k*c');
        x_m1(1:4) = x_m1(1:4)/norm(x_m1(1:4)); % quaternion normalization 
        %y(:, m+1) = x_m1;
        x_m = x_m1;
    end

    % Output last value at time t+T
    x_new = x_m;
end