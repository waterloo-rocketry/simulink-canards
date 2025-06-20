%% Run Sim

configure_plant_model
simout = sim("plant-model\CC_Flight_Simulation");

%% Post processing
[sdt, sdt_vars] = sim_postprocessor(simout);

%% Save 
% save("monte-carlo/sim_recent.mat", "sdt", "sdt_vars");
load("monte-carlo/sim_recent.mat", "sdt", "sdt_vars");


%% Plots
% figure(1)
% plot(sdt.rocket.Time, sdt.rocket.q)
% hold on
% stairs(sdt.est.Time, sdt.est.q)
% hold off

% figure(2)
% subplot(2,3,1)
% stairs(sdt.error.Time, sdt.error.q)
% subplot(2,3,4)
% stairs(sdt.error.Time, sdt.error.w)
% subplot(2,3,2)
% stairs(sdt.error.Time, sdt.error.v)
% subplot(2,3,5)
% stairs(sdt.error.Time, sdt.error.alt)
% subplot(2,3,3)
% stairs(sdt.error.Time, sdt.error.cl)
% subplot(2,3,6)
% stairs(sdt.error.Time, sdt.error.delta)
% 
figure(2)
plot_est_dashboard(sdt.error, "");
sgtitle("Estimation Error")

figure(3)
stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
legend("Roll angle", "Reference", "Roll control error")

figure(4)
plots_1 = plot_est_dashboard(sdt.est, "\_est", 'on');
plot_est_dashboard(sdt.rocket_dt, "\_sim", 'off', plots_1);

function [plots] = plot_est_dashboard(dataset, varargin)
     if nargin == 1 || nargin == 2 || nargin == 3
        tiledlayout(2,3,'TileSpacing','Compact');
        plots.q = nexttile; plots.w = nexttile; plots.v = nexttile; plots.alt = nexttile; 
        plots.cl = nexttile; plots.delta = nexttile;
     elseif nargin == 4
        plots = varargin{3};
     end

    if nargin >= 2
        name = varargin{1};
    else
        name = "";
    end
    
    names = append(["qw","qx","qy","qz"],name);
    for i = 1:4
        stairs(plots.q, dataset.Time, dataset.q(:,i), 'DisplayName', names(i));
        hold(plots.q, 'on')
    end
    legend(plots.q, 'show', 'FontSize', 7)
    ylabel(plots.q, "Quaternion")

    names = append(["wx","wy","wz"],name);
    for i = 1:3
        stairs(plots.w, dataset.Time, dataset.w(:,i), 'DisplayName', names(i))
        hold(plots.w, 'on')
    end
    legend(plots.w, 'show')
    ylabel(plots.w, "Angular Rates [rad/s]")

    names = append(["vx","vy","vz"],name);
    for i = 1:3
        stairs(plots.v, dataset.Time, dataset.v(:,i), 'DisplayName', names(i))
        hold(plots.v, 'on')
    end
    legend(plots.v, 'show')
    ylabel(plots.v, "Velocity [m/s]")

    names = append("alt",name);
    for i = 1
        stairs(plots.alt, dataset.Time, dataset.alt(:,i), 'DisplayName', names(i))
        hold(plots.alt, 'on')
    end
    legend(plots.alt, 'show')
    ylabel(plots.alt, "Altitude [m]")

    names = append("CL",name);
    for i = 1
        stairs(plots.cl, dataset.Time, dataset.cl(:,i), 'DisplayName', names(i))
        hold(plots.cl, 'on')
    end
    legend(plots.cl, 'show')
    ylabel(plots.cl, "Canard Coefficient")

    names = append("delta",name);
    for i = 1
        stairs(plots.delta, dataset.Time, dataset.delta(:,i), 'DisplayName', names(i))
        hold(plots.delta, 'on')
    end
    legend(plots.delta, 'show')
    ylabel(plots.delta, "Canard Angle [rad]")

    if  nargin == 3 || nargin == 4
        enablehold = varargin{2};
    else
        enablehold = 'off';
    end
    hold([plots.q, plots.w, plots.v, plots.alt, plots.cl, plots.delta], enablehold)
end