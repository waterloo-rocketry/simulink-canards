function [Jx, Ju] = jacobian(f, t, x, u, h)
    % Computes the Jacobian matrix of a vector function using complex-step
    % differentiation

    y = f(t, x, u);
    
    n = length(x);
    m = length(u);
    l = length(y);
    
    Jx = zeros(l,n);
    for k = 1:n
        one = zeros(n,1);
        one(k) = 1;
        Jx(:,k) = imag(f(t, x+1i*h*one, u)) / h; 
    end

    Ju = zeros(l,m);
    for k = 1:m
        one = zeros(m,1);
        one(k) = 1;
        Ju(:,k) = imag(f(t, x, u+1i*h*one)) / h; 
    end
end