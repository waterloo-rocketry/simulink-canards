function [torque_roll] = canard_online(V_air_B, omega_B, p_dyn, lever_arm, delta, pos_r_chord_mean, C_normal_alpha_1, number)
    
    % relative velocity
    Vrel = V_air_B + cross(omega_B, lever_arm);
    
    u_radial = omega_B(1) * pos_r_chord_mean;
    alpha_local = atan2(u_radial, Vrel(1));
    incidence = delta - alpha_local;


    C_roll = incidence * C_normal_alpha_1 * ...;
    
    torque_roll = incidence * C_roll * ...;
end