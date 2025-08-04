function [plots] = plot_state(dataset, varargin)
    % plot simulation data on a dashboard for estimator visualization
    
     if nargin == 1 || nargin == 2 || nargin == 3
        tiledlayout(3,2,'TileSpacing','Compact');
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
    %legend(plots.q, 'show', 'FontSize', 7)
    title(plots.q, "Quaternion",'FontWeight','Normal')

    names = append(["wx","wy","wz"],name);
    for i = 1:3
        stairs(plots.w, dataset.Time, dataset.w(:,i), 'DisplayName', names(i))
        hold(plots.w, 'on')
    end
    %legend(plots.w, 'show')
    title(plots.w, "Rates [rad/s]",'FontWeight','Normal')

    names = append(["vx","vy","vz"],name);
    for i = 1:3
        stairs(plots.v, dataset.Time, dataset.v(:,i), 'DisplayName', names(i))
        hold(plots.v, 'on')
    end
    %legend(plots.v, 'show')
    title(plots.v, "Velocity [m/s]",'FontWeight','Normal')

    names = append("alt",name);
    for i = 1
        stairs(plots.alt, dataset.Time, dataset.alt(:,i) / 1000, 'DisplayName', names(i))
        hold(plots.alt, 'on')
    end
    %legend(plots.alt, 'show')
    title(plots.alt, "Altitude [km]",'FontWeight','Normal')

    names = append("CL",name);
    for i = 1
        stairs(plots.cl, dataset.Time, dataset.cl(:,i), 'DisplayName', names(i))
        hold(plots.cl, 'on')
    end
    %legend(plots.cl, 'show')
    title(plots.cl, "Canard Coefficient",'FontWeight','Normal')

    names = append("delta",name);
    for i = 1
        stairs(plots.delta, dataset.Time, rad2deg(dataset.delta(:,i)), 'DisplayName', names(i))
        hold(plots.delta, 'on')
    end
    %legend(plots.delta, 'show')
    title(plots.delta, "Canard Angle [deg]",'FontWeight','Normal')

    if  nargin == 3 || nargin == 4
        enablehold = varargin{2};
    else
        enablehold = 'off';
    end
    hold([plots.q, plots.w, plots.v, plots.alt, plots.cl, plots.delta], enablehold)
end