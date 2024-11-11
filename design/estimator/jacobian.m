function J = jacobian(f, x, h)
    % Computes the Jacobian matrix of a vector function using complex-step
    % differentiation
    
    y = f(x);
    
    m = length(x);
    n = length(y);
    
    J = zeros(n,m);
    for k = 1:n
        one = zeros(n,1);
        one(k) = 1;
        J(k) = imag(f(x+i*h*one)) / h; 
    end
end