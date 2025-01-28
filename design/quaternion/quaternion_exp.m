function [exp_q] = quaternion_exp(v)
    % quaternion exponential of vector

    %%% rotation parameters
    phi = norm(v);

    %%% inverse quaternion 
    exp_q = [cos(phi); sin(v)];
  end