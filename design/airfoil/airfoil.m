%% Canards
S = 0.002;
AR = 1; % aspect ratio
sweep_quarter = 30 * pi/180; % sweep angle at quarter-chord 


length = 1000;
Ma_max = 4;
Ma_vector = NaN(1,length);
CL_vector = NaN(7,length);
CL_alpha_avg = NaN(1,length);
L_alpha_avg = NaN(1,length);

for i = 1:length
    Ma = i*Ma_max/length;
    q = 1/2*1.2*(Ma*330)^2;
    CL_alpha = (pi*AR) / (1 + sqrt(1 + (AR/2*cos(sweep_quarter))^2));

    % Stengel
    CL_alpha_i = (pi*AR) / (1 + sqrt(1 + (AR/2*cos(sweep_quarter))^2 * abs(1 - Ma^2*cos(sweep_quarter))) );
    CL_alpha_c = (1.8 + AR) / (1.8 + sqrt(abs(1-Ma^2))*AR) * CL_alpha_i; 
    CL_alpha_c2 = (1.8 + AR) / (1.8 + sqrt(abs(1-Ma^2))*AR) * (pi*AR) / (1 + sqrt(1 + (AR/2*cos(sweep_quarter)^2)));
    CL_alpha_delta_super = 4/sqrt(abs(Ma^2-1));
    % Todo: according to Stengel pp. 72, include Mach cone of rocket nosecone (p. 73)
    
    % Clarkson Uni
    CL_alpha_sub = CL_alpha / ( sqrt(abs(1-Ma^2+(CL_alpha/(pi*AR))^2)) + CL_alpha/(pi*AR));
    CL_alpha_super = 4/sqrt(abs(Ma^2-1)) * (1 - 1/(2*AR*sqrt(abs(Ma^2-1))));

    % export
    Ma_vector(1,i) = Ma;
    Prandtl(1,i) = 1/sqrt(abs(1-Ma^2));
    
    CL_vector(7,i) = CL_alpha;
    CL_vector(1,i) = CL_alpha_i;
    CL_vector(2,i) = CL_alpha_c;
    CL_vector(3,i) = CL_alpha_c2;
    if Ma <= 1
        CL_vector(5,i) = CL_alpha_sub;
    end
    if Ma >= 1
        CL_vector(4,i) = CL_alpha_delta_super;
        CL_vector(6,i) = CL_alpha_super;
    end
    CL_alpha_avg(1,i) = mean(CL_vector(:,i),"omitmissing");

    L_alpha_avg(1,i) = q*CL_alpha_avg(1,i)*S;
    L_vector(7,i) = q*CL_alpha*S;
    L_vector(1,i) = q*CL_alpha_i*S;
    L_vector(2,i) = q*CL_alpha_c*S;
    L_vector(3,i) = q*CL_alpha_c2*S;
    if Ma < 1
        L_vector(5,i) = q*CL_alpha_sub*S;
    end
    if Ma > 1
        L_vector(4,i) = q*CL_alpha_delta_super*S;
        L_vector(6,i) = q*CL_alpha_super*S;
    end
end

%% get polynom fit
% [Ma_vector_prep, CL_alpha_avg_prep] = prepareCurveData(Ma_vector', CL_alpha_avg');
% CL_fit = fit(Ma_vector_prep, CL_alpha_avg_prep,'poly5', fitoptions('poly5', 'Normalize', 'on', 'Robust', 'Bisquare'));
% plot(CL_fit);
% coeffs = coeffvalues(CL_fit)

%% plot CL_alpha

figure(1)
plot(Ma_vector, CL_alpha_avg,"k--");
hold on;
plot(Ma_vector, CL_vector(1,:));
plot(Ma_vector, CL_vector(2,:));
plot(Ma_vector, CL_vector(3,:));
plot(Ma_vector, CL_vector(4,:));
plot(Ma_vector, CL_vector(5,:));
plot(Ma_vector, CL_vector(6,:));
plot(Ma_vector, CL_vector(7,:));
plot(Ma_vector, CL_alpha_avg,"k--");
hold off
ylim([0,3]);
xlabel("Ma");
legend("Average","Incompressible", "Compressible", "Compressible2","Delta Supersonic Lead", "LowAR Subsonic","LowAR Supersonic","LowAR const")
title("CL_{\alpha}");

%% Plot L
figure(2)
semilogy(Ma_vector, L_alpha_avg,"k--");
hold on;
semilogy(Ma_vector, L_vector(1,:));
semilogy(Ma_vector, L_vector(2,:));
semilogy(Ma_vector, L_vector(3,:));
semilogy(Ma_vector, L_vector(4,:));
semilogy(Ma_vector, L_vector(5,:));
semilogy(Ma_vector, L_vector(6,:));
semilogy(Ma_vector, L_vector(7,:));
hold off
%ylim([0,10]);
xlabel("Ma");
legend("Average","Incompressible", "Compressible", "Compressible2","Delta Supersonic Lead", "LowAR Subsonic","LowAR Supersonic","LowAR const")
title("L_{\alpha}");