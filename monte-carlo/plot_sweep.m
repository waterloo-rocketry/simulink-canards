%% Configure
batch_name = '_all_200';
number_plots = 200;
exclude = [57, 173, 187]; %indices
size_limit = 4000; %kB


%% Plot statistical
% Preallocate arrays/cells to hold data for all simulations
all_error = cell(number_plots, 1);
all_control_ref = cell(number_plots, 1);
all_control_roll = cell(number_plots, 1);
all_est = cell(number_plots, 1);
all_rocket_dt = cell(number_plots, 1);
all_time = cell(number_plots, 1);

for k = 1:number_plots
    if ismember(k, exclude)
        continue  % skip excluded simulations
    end
    filename = sprintf('monte-carlo/batch%s/sim_%d.mat', batch_name, k);
    load(filename, "sdt");
    
    all_error{k} = sdt.error;
    all_control_ref{k} = sdt.control.ref;
    all_control_roll{k} = sdt.control.roll;
    all_time{k} = sdt.control.Time;
    all_est{k} = sdt.est;
    all_rocket_dt{k} = sdt.rocket_dt;
end
plot_multiple_errors(all_error)
plot_all_controls(all_time, all_control_ref, all_control_roll)
plot_multiple_estimations(all_est, all_rocket_dt)

%% Plot individual
for k = 1:number_plots
    k
    filename = sprintf('monte-carlo/batch%s/sim_%d.mat', batch_name, k);

    if ismember(k, exclude)
        continue  % skip excluded simulations
    elseif dir(filename).bytes / 1024 > size_limit
        continue  % skip excluded simulations
    end

    load(filename, "sdt");

    if k == 1
        figure(1)
        plots_err = plot_est_dashboard(sdt.error, "", 'on');
        sgtitle("Estimation Error")

        figure(2)
        stairs(sdt.control.Time, rad2deg([sdt.control.ref, sdt.control.roll]))
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
        stairs(sdt.control.Time, rad2deg([sdt.control.ref, sdt.control.roll]))
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
        stairs(sdt.control.Time, rad2deg([sdt.control.ref, sdt.control.roll]))
        % legend("Reference", "Roll angle", "Roll control error")
        ylabel("Angle [deg]")
        
        figure(3)
        plot_est_dashboard(sdt.est, "\_est", 'on', plots_est);
        plot_est_dashboard(sdt.rocket_dt, "\_sim", 'on', plots_est);
    end
end