function [x, P] = ekf_correct(x, P, y, R)
    innovation = y - model_h(x);
    H = model_H(x);
    S = H*P*H' + R;
    K = P*H' * inv(S);
    x = x + K*innovation;
    P = (eye(length(P)) - K*H ) * P;
end