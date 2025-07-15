%% Plot
batch_name = '_wind';
number_plots = 8;

for k = 1:number_plots
    filename = sprintf('monte-carlo/batch%s/sim_%d.mat', batch_name, k);
    load(filename, "sdt");

    if k == 1
        figure(1)
        plots_err = plot_est_dashboard(sdt.error, "", 'on');
        sgtitle("Estimation Error")

        figure(2)
        stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
        hold on
        % legend("Reference", "Roll angle", "Roll control error")
        ylabel("Angle [deg]")
        
        figure(3)
        plots_est = plot_est_dashboard(sdt.est, "\_est", 'on');
        plot_est_dashboard(sdt.rocket_dt, "\_sim", 'on', plots_est);

    elseif k == number_plots
        figure(1)
        plot_est_dashboard(sdt.error, "", 'off', plots_err);
        sgtitle("Estimation Error")
        
        figure(2)
        stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
        hold off
        % legend("Reference", "Roll angle", "Roll control error")
        ylabel("Angle [deg]")
        
        figure(3)
        plot_est_dashboard(sdt.est, "\_est", 'on', plots_est);
        plot_est_dashboard(sdt.rocket_dt, "\_sim", 'off', plots_est);
        
    else
        figure(1)
        plot_est_dashboard(sdt.error, "", 'on', plots_err);
        sgtitle("Estimation Error")
        
        figure(2)
        stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
        % legend("Reference", "Roll angle", "Roll control error")
        ylabel("Angle [deg]")
        
        figure(3)
        plot_est_dashboard(sdt.est, "\_est", 'on', plots_est);
        plot_est_dashboard(sdt.rocket_dt, "\_sim", 'on', plots_est);
    end
end