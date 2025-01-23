function [x_1] = solver_euler(f,T,step,t,x0,u) %#codegen
    % Computes solution of Vector-valued IVP using explicit Euler.
    % x_new at time t+T, using full size step
   
    x_dot = f(t, x0, u);
    x_1 = x0 + T*x_dot;

    x_1(1:4) = x_1(1:4)/norm(x_1(1:4)); % norm quaternions
end