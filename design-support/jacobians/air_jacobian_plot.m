a = -1000:1:50000;

for i = 1:length(a)
    p(i) = model_airdata(a(i));
    p_a(i) = - model_airdata_jacobian(a(i));
    p_diff(i) = p(i) - model_airdata(a(i) + 1);
end
figure(1)
plot(p,a)
figure(2)
plot(p_a,a)
hold on
plot(p_diff,a, ":")
hold off