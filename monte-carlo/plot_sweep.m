%% Configure
batch_name = '_test';
number_plots = 16;
% exclude = [88, 177]; %indices
% limit_filesize = 4000; %kB
% limit_velocity = 1000;


%% Plot statistical
sdt_array = cell(1, number_plots);
for k = 1:number_plots
    filename = sprintf('monte-carlo/batch%s/sim_%d.mat', batch_name, k);
    load(filename);  % loads variables: sdt, in_vars
    % if any(sdt.est.v(:,1) > limit_velocity) 
    %     continue    % skip these for now
    % end
    sdt_array{k} = sdt;  % store the sdt struct
end

percentiles = [40, 60];
figure(1)
plot_stats_state(sdt_array, 'rocket_dt', 'Simulation', percentiles);
figure(2)
plot_stats_state(sdt_array, 'est', 'Estimation', percentiles);
figure(3)
plot_stats_state(sdt_array, 'error', 'Estimation error', percentiles);
figure(4)
plot_stats_covariance(sdt_array, 'P_norm', 'Covariance norm', percentiles);
figure(5)
plot_stats_control(sdt_array, 'control', 'Controller', percentiles);

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