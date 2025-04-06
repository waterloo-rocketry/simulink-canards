syms qw qx qy qz vx vy vz real

q = [qw qx qy qz]';
v = [vx vy vz]';

assume(q, "real")
assume(v, "real")

%S = quaternion_rotmatrix(q);

J_s = jacobian(quaternion_rotmatrix(q)*v, q)

J_r = jacobian(quaternion_rotate(q, v), q)

J_q = quaternion_rotate_jacobian(q, v)

isequal(J_s, J_q)
isequal(J_r, J_q)