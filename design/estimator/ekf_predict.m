function [x_new, P_new] = ekf_predict(x, P, u, Q, T, step)
        
    % x_dot = model_f(x, u);
    [~,x_pred] = ode45(@(x_)model_f(x_, u), 0:step:T, x); % RK45 (DoPri)
    x_new = x_pred(end,:)';

    % P_dot = F*P + P*F'+ Q
    F1 = model_F(x, u); 
    F2 = model_F(x_new, u); 
    P_new = P + T/2*( (F1*P + P*F1'+ Q) + (F2*P + P*F2'+ Q) ); %trapezoidal rule 
end