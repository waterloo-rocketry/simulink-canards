% configure_plant_model

% out = sim("plant-model\CC_Flight_Simulation");

%%% Controller
sd.ref = sim_getdata(out, "ref", 1);
sd.ci = sim_getdata(out, "controlinput", 5);
sd.roll = sd.ci(:,[1,2]);
sd.controller = [sd.roll, sd.ref(:,2), sd.ref(:,2)-sd.roll(:,2)];

%%% Estimator
[sd.q, sdt.q] = sim_getdata(out, "q", 4);
[sd.w, sdt.w] = sim_getdata(out, "w", 3);
[sd.v, sdt.v] = sim_getdata(out, "v", 3);
[sd.pos, sdt.pos] = sim_getdata(out, "pos", 3);
[sd.cl, sdt.cl] = sim_getdata(out, "CL", 1);
[sd.delta, sdt.delta] = sim_getdata(out, "delta", 1);

[sd.qhat, sdt.qhat] = sim_getdata(out, "q_hat", 4);
[sd.what, sdt.what] = sim_getdata(out, "w_hat", 3);
[sd.vhat, sdt.vhat] = sim_getdata(out, "v_hat", 3);
[sd.althat, sdt.althat] = sim_getdata(out, "alt_hat", 1);
[sd.clhat, sdt.clhat] = sim_getdata(out, "cl_hat", 1);
[sd.deltahat, sdt.deltahat] = sim_getdata(out, "delta_hat", 1);

sdt.qerr = sim_ttdiff(sdt.q, sdt.qhat, "err");
sdt.werr = sim_ttdiff(sdt.w, sdt.what, "err");
sdt.verr = sim_ttdiff(sdt.v, sdt.vhat, "err");
sdt.alterr = sim_ttdiff(sdt.pos, sdt.althat, "err");
sdt.clerr = sim_ttdiff(sdt.cl, sdt.clhat, "err");
sdt.deltaerr = sim_ttdiff(sdt.delta, sdt.deltahat, "err");

%%% Plots
figure(1)
plot(sdt.q.Time, sdt.q.q)
hold on
stairs(sdt.qhat.Time, sdt.qhat.q_hat)
hold off

figure(2)
subplot(2,3,1)
stairs(sdt.qerr.Time, sdt.qerr.err)
subplot(2,3,4)
stairs(sdt.werr.Time, rad2deg(sdt.werr.err))
subplot(2,3,2)
stairs(sdt.verr.Time, sdt.verr.err)
subplot(2,3,5)
stairs(sdt.alterr.Time, sdt.alterr.err(:,1))
subplot(2,3,3)
stairs(sdt.verr.Time, sdt.clerr.err)
subplot(2,3,6)
stairs(sdt.verr.Time, rad2deg(sdt.deltaerr.err))

figure(3)
stairs(sd.controller(:,1), rad2deg(sd.controller(:,2:end)))
legend("Roll angle", "Reference", "Roll control error")


%%% functions
function [array, timetable] = sim_getdata(sim_out, name, dimension)
    timearray = getElement(sim_out.logsout, name).Values.Time;
    array = [timearray, reshape(getElement(sim_out.logsout, name).Values.Data, dimension, [])'];
    timetable = timeseries2timetable(getElement(sim_out.logsout, name).Values);
end

function [timetable_difference] = sim_ttdiff(tt_sim, tt_est, name)
    tt_sync = synchronize(tt_sim, tt_est, tt_est.Time);
    array_diff = table2array(tt_sync(:,1)) - table2array(tt_sync(:,2));
    timetable_difference = timetable(tt_sync.Time, array_diff, 'VariableNames', name);
end