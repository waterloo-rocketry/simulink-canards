function plot_stats_control(sdt_array, type, commontitle, percentiles)
    % Plot the mean and standard deviation across multiple simulations
    % Input: sdt_array - cell array of sdt structs

    N = numel(sdt_array);
    fields = {'ref', 'err', 'cmd', 'roll', 'rate', 'delta'};
    names = {'Reference [rad]', 'Roll error [rad]', 'Command [rad]', 'Roll angle [rad]', 'Rates [rad/s]', 'Actuation [rad]',};
    dims = [1, 1, 1, 1, 1, 1];

    % Preallocate
    T_length_max = 0;
    valid_idx = [];  
    for n = 1:N
        sdt = sdt_array{n};
        if ~isstruct(sdt) || ~isfield(sdt, type) || isempty(sdt.(type)) || isfield(sdt.(type), 'Time') || isempty(sdt.(type).Time)
            continue;
        end
        T_now = sdt.(type).Time;
        T_length = length(T_now);
        if T_length > T_length_max 
            T_length_max = T_length;
            T_ref = T_now;
        end
        valid_idx(end+1) = n;  %#ok<AGROW>
    end
    
    num_valid = numel(valid_idx);
    if num_valid == 0
        warning('No valid simulations found. Skipping plot.');
        return;
    end

    % Initialize storage
    for f = 1:numel(fields)
        all_data.(fields{f}) = zeros(num_valid, dims(f), N);
    end

    % Gather data
    for i = 1:num_valid
        k = valid_idx(i);
        sdt = sdt_array{k};
        % Skip if not a struct or missing expected field
        if ~isstruct(sdt) || ~isfield(sdt, type) || isempty(sdt.(type))
            warning('Skipping sdt_array{%d} — invalid or empty', k);
            continue;
        end
        data_ts = sdt.(type);
        for f = 1:numel(fields)
            field = fields{f};
            data = data_ts.(field);
            all_data.(field)(1:length(data),:,k) = data;
        end
    end

    % Colors
    var_colors(1,:) = [0.00, 0.45, 0.74];  % Deep Blue (unchanged)
    var_colors(2,:) = [0.00, 0.60, 0.20];  % Clear Green
    var_colors(3,:) = [1.00, 0.50, 0.00];  % True Orange
    var_colors(4,:) = [0.60, 0.20, 0.50];  % Warmer Purple (less blue, more magenta)

    % Plotting
    tlo = tiledlayout(2,3,'TileSpacing','Compact','Padding','Compact');
    axes_list = [];
    for f = 1:numel(fields)
        ax = nexttile;
        axes_list(end+1) = ax;
        field = fields{f};
        name = names{f};
        dim = dims(f);

        hold(ax, 'on');
        for d = 1:dim
            color = var_colors(d,:);
            data = squeeze(all_data.(field)(:,d,:));  % [time x runs]
            % mu = mean(data, 2);
            mu = median(data, 2, "omitmissing");
            sigma = std(data, 0, 2);
            lower_mid = prctile(data, (100-percentiles(1))/2, 2);
            upper_mid = prctile(data, 100-(100-percentiles(1))/2, 2);
            lower = prctile(data, (100-percentiles(2))/2, 2);
            upper = prctile(data, 100-(100-percentiles(2))/2, 2);
            
            
            % Shaded area for ±1σ
            fill([T_ref; flipud(T_ref)], ...
                 [upper; flipud(lower)], ... % [mu+sigma; flipud(mu-sigma)],...
                 color, 'FaceAlpha', 0.15, 'EdgeColor', 'none', 'Parent', ax);

            % Mean line
            plot(ax, T_ref, mu, 'Color', color, 'LineWidth', 1.5);
            plot(T_ref, lower_mid, ':', 'Color', color, 'LineWidth', 1, 'Parent', ax);
            plot(T_ref, upper_mid, ':', 'Color', color, 'LineWidth', 1, 'Parent', ax);
        end
        title(ax, name,'FontWeight','Normal');
        grid(ax, 'on');
        % xlabel(ax, 'Time [s]');
    end


    % Add common
    % legend(axes_list(1), 'Median ± 95%', 'FontSize', 7, 'Location', 'best');
    title(tlo, commontitle)

    % legend
    % Median & percentile handles (in black)
    h_median = plot(nan, nan, '-', 'Color', [0 0 0], 'LineWidth', 1.5);
    h_perc1 = plot(nan, nan, ':', 'Color', [0 0 0], 'LineWidth', 1);
    h_fill = fill(nan, nan, [0 0 0], 'FaceAlpha', 0.15, 'EdgeColor', 'none');
    
    % Combine all legend handles
    all_handles = [h_median, h_perc1, h_fill];
    
    % Create labels for the legend
    labels{1} = 'Med.';
    labels{2} = sprintf('%d%%', percentiles(1));
    labels{3} = sprintf('%d%%', percentiles(2));

    % Create legend'
    lgd = legend(ax, all_handles, labels, 'FontSize', 8, 'Orientation', 'horizontal', 'NumColumns', 3);
    set(lgd, 'Units', 'normalized');
    lgd.Position(1:2) = [0.56, 0.97];
end
