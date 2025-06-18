%% Run Sim

configure_plant_model
out = sim("plant-model\CC_Flight_Simulation");

%% Post processing

%%% Controller
sdt_vars.ref = sim_getdata(out, "ref", 1);
sdt_vars.control = sim_getdata(out, "controlinput", 5);
sdt_vars.cmd = sim_getdata(out, "cmd", 1);

sdt_vars.roll = timetable(sdt_vars.control.Time, sdt_vars.control.controlinput(:,1), 'VariableNames', "roll");
sdt_vars.rollerr = sim_ttdiff(sdt_vars.ref, sdt_vars.roll, "err");
sdt.control = synchronize(sdt_vars.ref, sdt_vars.roll, sdt_vars.rollerr);

%%% Rockets
sdt_vars.q = sim_getdata(out, "q", 4);
sdt_vars.w = sim_getdata(out, "w", 3);
sdt_vars.v = sim_getdata(out, "v", 3);
sdt_vars.pos = sim_getdata(out, "pos", 3);
    sdt_vars.alt = timetable(sdt_vars.pos.Time, sdt_vars.pos.pos(:,1), 'VariableNames', "alt");
sdt_vars.cl = sim_getdata(out, "CL", 1);
sdt_vars.delta = sim_getdata(out, "delta", 1);
sdt.rocket = synchronize(sdt_vars.q, sdt_vars.w, sdt_vars.v, sdt_vars.alt, sdt_vars.cl, sdt_vars.delta);
    sdt.rocket = renamevars(sdt.rocket, 1:6, ["q", "w", "v", "alt", "cl", "delta"]);

%%% Estimator
sdt_vars.qhat = sim_getdata(out, "q_hat", 4);
sdt_vars.what = sim_getdata(out, "w_hat", 3);
sdt_vars.vhat = sim_getdata(out, "v_hat", 3);
sdt_vars.althat = sim_getdata(out, "alt_hat", 1);
sdt_vars.clhat = sim_getdata(out, "cl_hat", 1);
sdt_vars.deltahat = sim_getdata(out, "delta_hat", 1);
sdt.est = synchronize(sdt_vars.qhat, sdt_vars.what, sdt_vars.vhat, sdt_vars.althat, sdt_vars.clhat, sdt_vars.deltahat);
    sdt.est = renamevars(sdt.est, 1:6, ["q", "w", "v", "alt", "cl", "delta"]);

sdt_vars.qerr = sim_ttdiff(sdt_vars.q, sdt_vars.qhat, "err");
sdt_vars.werr = sim_ttdiff(sdt_vars.w, sdt_vars.what, "err");
sdt_vars.verr = sim_ttdiff(sdt_vars.v, sdt_vars.vhat, "err");
sdt_vars.alterr = sim_ttdiff(sdt_vars.alt, sdt_vars.althat, "err"); 
sdt_vars.clerr = sim_ttdiff(sdt_vars.cl, sdt_vars.clhat, "err");
sdt_vars.deltaerr = sim_ttdiff(sdt_vars.delta, sdt_vars.deltahat, "err");
sdt.error = synchronize(sdt_vars.qerr, sdt_vars.werr, sdt_vars.verr, sdt_vars.alterr, sdt_vars.clerr, sdt_vars.deltaerr);
    sdt.error = renamevars(sdt.error, 1:6, ["q", "w", "v", "alt", "cl", "delta"]);

sdt.rocket_dt = retime(sdt.rocket, sdt.est.Time);

%% Save 
save("monte-carlo/sim_recent.mat", "sdt", "sdt_vars");


%% Plots
figure(1)
plot(sdt.rocket.Time, sdt.rocket.q)
hold on
stairs(sdt.est.Time, sdt.est.q)
hold off

figure(2)
subplot(2,3,1)
stairs(sdt.error.Time, sdt.error.q)
subplot(2,3,4)
stairs(sdt.error.Time, sdt.error.w)
subplot(2,3,2)
stairs(sdt.error.Time, sdt.error.v)
subplot(2,3,5)
stairs(sdt.error.Time, sdt.error.alt)
subplot(2,3,3)
stairs(sdt.error.Time, sdt.error.cl)
subplot(2,3,6)
stairs(sdt.error.Time, sdt.error.delta)

figure(3)
stairs(sdt.control.Time, rad2deg(sdt.control.Variables))
legend("Roll angle", "Reference", "Roll control error")


%% functions
function [timetable, array] = sim_getdata(sim_out, name, dimension)
    timearray = getElement(sim_out.logsout, name).Values.Time;
    array = [timearray, reshape(getElement(sim_out.logsout, name).Values.Data, dimension, [])'];
    timetable = timeseries2timetable(getElement(sim_out.logsout, name).Values);
end

function [timetable_difference] = sim_ttdiff(tt_sim, tt_est, name)
    tt_sync = synchronize(tt_sim, tt_est, tt_est.Time);
    array_diff = table2array(tt_sync(:,1)) - table2array(tt_sync(:,2));
    timetable_difference = timetable(tt_sync.Time, array_diff, 'VariableNames', name);
end