function plot_animation(sdt)
    % Plays animation and saves video file
    
    %%% get Euler angles
    euler = zeros(height(sdt.rocket_dt.q),3);
    for t = 1:height(sdt.rocket_dt.q)
        q = sdt.rocket_dt.q(t,:)';
        euler(t,:) = quaternion_to_euler(q)';
    end
    tt.euler = timetable(sdt.rocket_dt.Time, euler, 'VariableNames', "euler");
    
    eulerhat = zeros(height(sdt.est.q),3);
    for t = 1:height(sdt.est.q)
        qhat = sdt.est.q(t,:)';
        eulerhat(t,:) = quaternion_to_euler(qhat)';
    end
    tt.eulerhat = timetable(sdt.rocket_dt.Time, eulerhat, 'VariableNames', "euler");

    
    %%% Animation
    
    h = Aero.Animation;
    h.FramesPerSecond = 30;
    h.TimeScaling = 1;
    h.createBody('testrocket.ac', 'Ac3d');
    h.createBody('testrocket.ac', 'Ac3d');
    h.createBody('ac3d_xyzisrgb.ac', 'Ac3d');
    animationdata = [seconds(sdt.rocket_dt.Time), sdt.rocket_dt.alt, sdt.rocket_dt.pos_yz, table2array(tt.euler)];
    animationdata = fillmissing(animationdata, 'linear');
    animationdata_hat = [seconds(sdt.rocket_dt.Time), sdt.rocket_dt.alt, sdt.rocket_dt.pos_yz, table2array(tt.eulerhat)];
    animationdata_hat(:,3) = animationdata_hat(:,3) + 3;
    animationdata_hat = fillmissing(animationdata_hat, 'linear');
    h.Bodies{1}.TimeSeriesSource = animationdata;
    h.Bodies{2}.TimeSeriesSource = animationdata_hat;
    h.Bodies{3}.TimeSeriesSource = [[0;animationdata(end,1)], repmat([animationdata(1,2:4)+[-4,0,0], deg2rad([0, 0, 90])], 2, 1)];
    h.updateBodies(0);
    h.Camera.PositionFcn = @staticCameraZoom;
    h.Camera.UpVector = [1, 0, 0];
    h.Camera.Offset = [250, 0, -2000];
    h.updateCamera(0);
    h.show();
    h.VideoRecord = 'on';
    h.VideoQuality = 70;
    h.VideoCompression = 'MPEG-4';
    h.VideoFilename = 'monte-carlo/animation';
    h.VideoTStart = 0;
    h.VideoTFinal = 60;
    h.play();
    % h.wait();
    % h.hide();
    % h.VideoRecord = 'off';
    % h.delete();
end

function staticCameraZoom(~, Bodies, h)

    if ~isempty(Bodies) && isa(Bodies, 'cell') && isa(Bodies{1},'Aero.Body')
    target     = Bodies{1};
    targetPos  = target.Position;
    else
        targetPos = h.AimPoint; % don't change anything
    end
    
    viewExtent = h.ViewExtent;
    
    %--- Extent of view to render
    
    h.xlim = targetPos(1) + viewExtent;
    h.ylim = targetPos(2) + viewExtent;
    h.zlim = targetPos(3) + viewExtent;
    
    %--- Camera aim point for [x,y,z] aim point
    
    h.AimPoint = targetPos;

    h.Position = h.Offset;

    h.ViewAngle = asin(500/norm(targetPos-h.Offset));
end