function [Jx] = jacobian(f, t, x, u, h)
    % Computes the Jacobian matrix of a vector function using complex-step differentiation
    % Inputs: ODE function f, time t, state x, step size h
    % Outputs: Jacobian matrix del_f/del_x

    h = 0.001; % step size overwrite

    n = length(x); % size of input
    y = f(t, x, u);
    l = length(y); % size of output
    
    Jx = zeros(l,n); % prep Jacobian array

    for k = 1:n
        one = zeros(n,1);
        one(k) = 1;
        Jx(:,k) = imag(f(t, x+1i*h*one, u)) / h; 
    end
end