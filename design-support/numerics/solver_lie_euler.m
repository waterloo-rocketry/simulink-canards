function [x_new] = solver_lie_euler(f,T,step,t,x0,u) %#codegen
    % Computes solution of Vector-valued IVP using a mix of Crouch-Grossman 1 and explicit Euler.
    % x_new at time t+T, using step size step
    % Crouch-Grossman is used for quaternion integration, and is a Lie group geometric integration method which preserves the unit quaternion
    % Quaternion is state x(1:4), body rates is state x(5:7)

    q = x0(1:4)/norm(x0(1:4));
    w = x0(5:7);
    x = x0(5:end);

    x_dot = f(t, x0, u);
    x_1 = x + T*x_dot(5:end);

    % W1 = quaternion_mult(x_dot(1:4), quaternion_inv(q))
    % [~, W2] = quaternion_deriv(q, x(5:7))
    % W = W2;

    q_delta = quaternion_exp(T*w);
    q_1 =  quaternion_mult(q, q_delta);
    % norm(q_1)

    % Output value at time t+T
    x_new = [q_1; x_1];
end