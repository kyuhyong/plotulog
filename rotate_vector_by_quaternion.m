function v_rotated = rotate_vector_by_quaternion(v, q)
  % Rotates vector v by quaternion q
  q_v = [0, v];
  q_conj = [q(1), -q(2:4)]; % Conjugate of the quaternion
  q_v_rotated = quaternion_multiply(quaternion_multiply(q, q_v), q_conj);
  v_rotated = q_v_rotated(2:4);  % Extract the rotated vector part
endfunction

function q = quaternion_multiply(q1, q2)
  % Multiplies two quaternions
  w1 = q1(1); x1 = q1(2); y1 = q1(3); z1 = q1(4);
  w2 = q2(1); x2 = q2(2); y2 = q2(3); z2 = q2(4);
  q = [
    w1*w2 - x1*x2 - y1*y2 - z1*z2,
    w1*x2 + x1*w2 + y1*z2 - z1*y2,
    w1*y2 - x1*z2 + y1*w2 + z1*x2,
    w1*z2 + x1*y2 - y1*x2 + z1*w2
  ];
endfunction