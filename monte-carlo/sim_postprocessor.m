function [sdt, sdt_vars] = sim_postprocessor(simout)
    % Refines simulation data
    % Input parmaters: simout (Simulink.SimulationOutput)
    % Output parameters: sdt (struct with timetables of combined data), sdt_vars (struct with timetables of individual variables)
    
    %%% Controller data
    sdt_vars.ref = sim_getdata(simout, 'ref', 1);
    sdt_vars.control = sim_getdata(simout, 'controlinput', 5);
    sdt_vars.cmd = sim_getdata(simout, 'cmd', 1);
    
    sdt_vars.roll = timetable(sdt_vars.control.Time, sdt_vars.control.controlinput(:,1), 'VariableNames', 'roll');
    sdt_vars.rollerr = sim_ttdiff(sdt_vars.ref, sdt_vars.roll, 'err');
    sdt.control = synchronize(sdt_vars.ref, sdt_vars.roll, sdt_vars.rollerr);
    
    %%% Rocket data
    sdt_vars.q = sim_getdata(simout, 'q', 4);
    sdt_vars.w = sim_getdata(simout, 'w', 3);
    sdt_vars.v = sim_getdata(simout, 'v', 3);
    sdt_vars.pos = sim_getdata(simout, 'pos', 3);
        sdt_vars.alt = timetable(sdt_vars.pos.Time, sdt_vars.pos.pos(:,1), 'VariableNames', 'alt');
    sdt_vars.cl = sim_getdata(simout, 'CL', 1);
    sdt_vars.delta = sim_getdata(simout, 'delta', 1);
    sdt.rocket = synchronize(sdt_vars.q, sdt_vars.w, sdt_vars.v, sdt_vars.alt, sdt_vars.cl, sdt_vars.delta);
        sdt.rocket = renamevars(sdt.rocket, 1:6, ['q', 'w', 'v', 'alt', 'cl', 'delta']);
    
    %%% Estimator data
    sdt_vars.qhat = sim_getdata(simout, 'q_hat', 4);
    sdt_vars.what = sim_getdata(simout, 'w_hat', 3);
    sdt_vars.vhat = sim_getdata(simout, 'v_hat', 3);
    sdt_vars.althat = sim_getdata(simout, 'alt_hat', 1);
    sdt_vars.clhat = sim_getdata(simout, 'cl_hat', 1);
    sdt_vars.deltahat = sim_getdata(simout, 'delta_hat', 1);
    sdt.est = synchronize(sdt_vars.qhat, sdt_vars.what, sdt_vars.vhat, sdt_vars.althat, sdt_vars.clhat, sdt_vars.deltahat);
        sdt.est = renamevars(sdt.est, 1:6, ['q', 'w', 'v', 'alt', 'cl', 'delta']);
    
    sdt_vars.qerr = sim_ttdiff(sdt_vars.q, sdt_vars.qhat, 'err');
    sdt_vars.werr = sim_ttdiff(sdt_vars.w, sdt_vars.what, 'err');
    sdt_vars.verr = sim_ttdiff(sdt_vars.v, sdt_vars.vhat, 'err');
    sdt_vars.alterr = sim_ttdiff(sdt_vars.alt, sdt_vars.althat, 'err'); 
    sdt_vars.clerr = sim_ttdiff(sdt_vars.cl, sdt_vars.clhat, 'err');
    sdt_vars.deltaerr = sim_ttdiff(sdt_vars.delta, sdt_vars.deltahat, 'err');
    sdt.error = synchronize(sdt_vars.qerr, sdt_vars.werr, sdt_vars.verr, sdt_vars.alterr, sdt_vars.clerr, sdt_vars.deltaerr);
        sdt.error = renamevars(sdt.error, 1:6, ['q', 'w', 'v', 'alt', 'cl', 'delta']);

    sdt_vars.P_norm = sim_getdata(simout, 'P_norm', 3);

    % Rocket data in estimator time code
    sdt.rocket_dt = retime(sdt.rocket, sdt.est.Time);
end

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