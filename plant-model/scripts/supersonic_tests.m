mach = 0:0.02:3;
incidence = deg2rad(0:3:10);

height = 0.1;
midchord_angle = deg2rad(50);
area_planform = 0.01;

cp = zeros(length(mach), length(incidence));

for i = 1:length(incidence)
    for m = 1:length(mach)
        % cp(m, i) =  pressure_coeff_supersonic(mach(m), incidence(i));
        cp(m, i) =  aerosurface_online(mach(m), incidence(i), height, midchord_angle, area_planform);
    end
end

% figure(2)
plot(mach, cp(:, 1))
hold on
plot(mach, cp(:, 2))
plot(mach, cp(:, 3))
plot(mach, cp(:, 4))
% hold off

function [cp] = pressure_coeff_supersonic(mach, incidence)
    beta = max(sqrt(abs(1-mach.^2)), 0.5);
    % beta = sqrt(abs(1-M.^2));

    gamma = 1.4; % adiabatic exponent of air

    k1 = 2/beta;
    k2 = ( (gamma+1)*mach.^4 - 4*beta.^2 ) / (4 * beta.^4);
    k3 = ( (gamma+1)*mach.^8 + (2*gamma.^2-7*gamma-5)*mach.^6 + 10*(gamma+1)*mach.^4 + 8) / (6*beta.^7);

    cp = k1*incidence + k2*incidence.^2 + k3*incidence.^3;
end