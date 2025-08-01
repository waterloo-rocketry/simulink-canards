% Read data (if not already in workspace)
T_long = readtable('analysis/testflightomnibusloganal.xlsx', 'Sheet', 'proc_state_est'); 

% relevant times only
% keep only times between time_start and time_end
time_start = 1455; % ekf starts at 1403, liftoff around 1463
time_end = 1486;
time_end = 1490;

T_long.Var4 = [];
T_long.notes = [];

% Convert long to wide format
T = unstack(T_long, 'data', 'state_id');
% format names
oldNames = T.Properties.VariableNames;
newNames = strrep(oldNames, 'STATE_ID_', '');
T.Properties.VariableNames = newNames;

% replace NaN with previous 
T = fillmissing(T, 'previous');

% % Convert from milliseconds to seconds
T.timestamp_s = T.timestamp_ms / 1000;
T.timestamp_ms = [];

% rebase to new zero time
T = T(T.timestamp_s >= time_start & T.timestamp_s <= time_end, :);
T.timestamp_s = T.timestamp_s - T.timestamp_s(1);


%% process data
% euler angles
for i=1:height(T)
    q = [T.ATT_Q0(i), T.ATT_Q1(i), T.ATT_Q2(i), T.ATT_Q3(i)]';
    euler = quaternion_to_euler(q);
    T.euler_roll(i) = euler(1);
    T.euler_pitch(i) = euler(2);
    T.euler_yaw(i) = euler(3);
end

%% plot
set(groot, 'defaultAxesTickLabelInterpreter','latex')
set(groot, 'defaultLegendInterpreter','latex')
set(groot, 'DefaultTextInterpreter', 'latex')

figure(1)
stairs(T.timestamp_s, T.ATT_Q0, 'DisplayName', '$q_w$'); hold on;
stairs(T.timestamp_s, T.ATT_Q1, 'DisplayName', '$q_x$');
stairs(T.timestamp_s, T.ATT_Q2, 'DisplayName', '$q_y$');
stairs(T.timestamp_s, T.ATT_Q3, 'DisplayName', '$q_z$');
xlabel("Time [s]")
ylabel("Quaternion [ ]")
% title("Attitude quaternion") 
legend('Location','southwest'); hold off;

figure(2)
stairs(T.timestamp_s, T.euler_roll, 'DisplayName', 'roll'); hold on;
stairs(T.timestamp_s, T.euler_pitch, 'DisplayName', 'pitch');
stairs(T.timestamp_s, T.euler_yaw, 'DisplayName', 'yaw');
xlabel("Time [s]")
ylabel("Angle [rad]")
% title("Relative Euler angles")
legend('Location','southwest'); hold off;

figure(3)
stairs(T.timestamp_s, T.RATE_WX, 'DisplayName', '$\omega_x$'); hold on;
stairs(T.timestamp_s, T.RATE_WY, 'DisplayName', '$\omega_y$')
stairs(T.timestamp_s, T.RATE_WZ, 'DisplayName', '$\omega_z$')
xlabel("Time [s]")
ylabel("Anglular rate [rad/s]")
% title("Angular rates")
legend('Location','northwest'); hold off;

figure(4)
stairs(T.timestamp_s, T.VEL_VX, 'DisplayName', '$v_x$'); hold on;
stairs(T.timestamp_s, T.VEL_VY, 'DisplayName', '$v_y$');
stairs(T.timestamp_s, T.VEL_VZ, 'DisplayName', '$v_z$');
xlabel("Time [s]")
ylabel("Velocity [m/s]")
% title("Velocity")
legend('Location','best'); hold off;

figure(5)
stairs(T.timestamp_s, T.ALT, 'DisplayName', 'alt')
xlabel("Time [s]")
ylabel("Altitude [m]")
% title("Altitude")
%legend(); 
hold off;

figure(6)
stairs(T.timestamp_s, rad2deg(T.CANARD_ANGLE), 'DisplayName', '$\delta$'); hold on;
stairs(T.timestamp_s, T.COEFF_CL, 'DisplayName', '$C_L$')
xlabel("Time [s]")
ylabel("Angle [deg], Coefficient [ ]")
ylim([-1,5])
% title("Canard")
legend('Location','best'); hold off;

set(groot, 'defaultAxesTickLabelInterpreter','remove')
set(groot, 'defaultLegendInterpreter','remove')
set(groot, 'DefaultTextInterpreter', 'remove')