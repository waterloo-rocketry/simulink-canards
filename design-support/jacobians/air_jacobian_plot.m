a = -1000:2:50000;


for i = 1:length(a)
    p(i) = model_airdata(a(i)).pressure;
    p_a(i) = model_airdata_jacobian(a(i)).pressure;
    p_diff(i) = - p(i) + model_airdata(a(i) + 1).pressure;

    d(i) = model_airdata(a(i)).density;
    d_a(i) = model_airdata_jacobian(a(i)).density;
    d_diff(i) = - d(i) + model_airdata(a(i) + 1).density;

    m(i) = model_airdata(a(i)).mach;
    m_a(i) = model_airdata_jacobian(a(i)).mach;
    m_diff(i) = - m(i) + model_airdata(a(i) + 1).mach;
end

figure(1)

subplot(1,3,1)
plot(p_diff,a)
hold on
plot(p_a,a)
hold off
ylabel("Altitude [m]")
legend("Numerical", "Analytical")
xlabel("Pressure grad [Pa / m]")

subplot(1,3,2)
plot(d_diff,a)
hold on
plot(d_a,a)
hold off
legend("Numerical", "Analytical")
xlabel("Density grad [kg/m^3 / m]")

subplot(1,3,3)
plot(m_diff,a)
hold on
plot(m_a,a)
hold off
legend("Numerical", "Analytical")
xlabel("Sonic speed grad [m/s / m]")