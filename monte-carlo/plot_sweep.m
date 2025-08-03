%% Configure
batch_name = '_ascent_200';
number_plots = 200;
% exclude = [88, 177]; %indices
% limit_filesize = 4000; %kB
% limit_velocity = 1000;
percentiles = [80, 100];

%% Load statistical
sdt_array = cell(1, number_plots);
filename = sprintf('monte-carlo/batch%s/result_summary.mat', batch_name);
load(filename);
unstable_id
for k = 1:number_plots
    filename = sprintf('monte-carlo/batch%s/sim_%d.mat', batch_name, k);
    load(filename);  % loads variables: sdt, in_vars
    % if any(sdt.est.v(:,1) > limit_velocity) 
    if ismember(k, unstable_id) 
        continue    % skip these for now
    end
    sdt_array{k} = sdt;  % store the sdt struct
end


%% Plot statistical
f_sim = figure(1);
plot_stats_state(sdt_array, 'rocket_dt', 'Simulation', percentiles);
f_est = figure(2);
plot_stats_state(sdt_array, 'est', 'Estimation', percentiles);
f_error = figure(3);
plot_stats_state(sdt_array, 'error', 'Estimation error', percentiles);
f_cov = figure(4);
plot_stats_covariance(sdt_array, 'P_norm', 'Covariance', percentiles);
f_control = figure(5);
plot_stats_control(sdt_array, 'control', 'Controller', percentiles);

%% save statistical
set(f_sim, 'Units', 'normalized', 'WindowState', 'maximized');
saveas(f_sim, sprintf('monte-carlo/batch%s/result_stats_sim%s.png', batch_name, batch_name))
set(f_est, 'Units', 'normalized', 'WindowState', 'maximized');
saveas(f_est, sprintf('monte-carlo/batch%s/result_stats_est%s.png', batch_name, batch_name))
set(f_error, 'Units', 'normalized', 'WindowState', 'maximized');
saveas(f_error, sprintf('monte-carlo/batch%s/result_stats_error%s.png', batch_name, batch_name))
set(f_control, 'Units', 'normalized', 'WindowState', 'maximized');
saveas(f_control, sprintf('monte-carlo/batch%s/result_stats_control%s.png', batch_name, batch_name))
saveas(f_cov, sprintf('monte-carlo/batch%s/result_stats_cov%s.png', batch_name, batch_name))

%% Plot individual
if 0
    for k = 1:number_plots
        k
        filename = sprintf('monte-carlo/batch%s/sim_%d.mat', batch_name, k);
    
        if ismember(k, exclude)
            continue  % skip excluded simulations
        elseif dir(filename).bytes / 1024 > limit_filesize
            continue  % skip excluded simulations
        end
    
        load(filename, "sdt");
    
        if any(sdt.est.v(:,1) > limit_velocity) 
            continue    
        end
    
        if k == 1
            figure(1)
            plots_err = plot_state(sdt.error, "", 'on');
            sgtitle("Estimation Error")
    
            figure(2)
            stairs(sdt.control.Time, rad2deg([sdt.control.ref, sdt.control.roll]))
            hold on
            % legend("Reference", "Roll angle", "Roll control error")
            ylabel("Angle [deg]")
            
            figure(3)
            plots_est = plot_state(sdt.est, "\_est", 'on');
            plot_state(sdt.rocket_dt, "\_sim", 'on', plots_est);
    
        elseif k == number_plots
            figure(1)
            plot_state(sdt.error, "", 'off', plots_err);
            sgtitle("Estimation Error")
            
            figure(2)
            stairs(sdt.control.Time, rad2deg([sdt.control.ref, sdt.control.roll]))
            hold off
            % legend("Reference", "Roll angle", "Roll control error")
            ylabel("Angle [deg]")
            
            figure(3)
            plot_state(sdt.est, "\_est", 'on', plots_est);
            plot_state(sdt.rocket_dt, "\_sim", 'off', plots_est);
            
        else
            figure(1)
            plot_state(sdt.error, "", 'on', plots_err);
            sgtitle("Estimation Error")
            
            figure(2)
            stairs(sdt.control.Time, rad2deg([sdt.control.ref, sdt.control.roll]))
            % legend("Reference", "Roll angle", "Roll control error")
            ylabel("Angle [deg]")
            
            figure(3)
            plot_state(sdt.est, "\_est", 'on', plots_est);
            plot_state(sdt.rocket_dt, "\_sim", 'on', plots_est);
        end
    end
end