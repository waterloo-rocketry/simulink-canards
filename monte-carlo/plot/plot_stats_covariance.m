function plot_stats_covariance(sdt_array, type, commontitle, percentiles)
    % Plot the mean and standard deviation across multiple simulations
    % Input: sdt_array - cell array of sdt structs

    N = numel(sdt_array);
    fields = {'P_norm'};
    names = {'det(P)', '1-norm ', '2-norm', 'inf-norm'};
    dims = 4;

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
    all_data.(fields{1}) = zeros(num_valid, dims(1), N);

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
        field = fields{1};
        data = data_ts.(field);
        all_data.(field)(1:length(data),:,k) = data;
    end

    % Colors
    var_colors(1,:) = [0.00, 0.45, 0.74];  % Deep Blue
    var_colors(2,:) = [0.00, 0.60, 0.20];  % Clear Green
    var_colors(3,:) = [1.00, 0.50, 0.00];  % True Orange
    var_colors(4,:) = [0.60, 0.20, 0.50];  % Warm Purple

    % Plotting
    tlo = tiledlayout(4,1,'TileSpacing','Compact','Padding','Compact');
    axes_list = [];
    for d = 1:dims
        ax = nexttile;
        axes_list(end+1) = ax;
        field = fields{1};
        name = names{d};
        % dim = dims(f);

        hold(ax, 'on');
        color = var_colors(d,:);
        data = squeeze(all_data.(field)(:,d,:));  % [time x runs]
        % mu = mean(data, 2);
        mu = median(data, 2, "omitmissing");
        % sigma = std(data, 0, 2);
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
        title(ax, name);
        grid(ax, 'on');
        xlabel(ax, 'Time [s]');
    end


    % Add common
    % legend(axes_list(1), 'Median ± 95%', 'FontSize', 7, 'Location', 'best');
    title(tlo, commontitle)
end
