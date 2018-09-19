function euler = quaternionToEuler(q0, q1, q2, q3)
  t0 = -2*(q2*q2 + q3*q3);
  t1 =  2*(q1*q2 + q0*q3);
  t2 = -2*(q1*q3 - q0*q2);
  t3 =  2*(q2*q3 + q0*q1);
  t4 = -2*(q1*q1 + q2*q2) + 1;
  
  if(t2 > 1) t2 = 1.0; endif;
  if(t2 < -1) t2 = -1; endif;
  
  roll  = atan2(t3, t4) * 180/pi;
  pitch = asin(t2) * 180/pi;
  yaw   = atan2(t1, t0) * 180/pi;
  euler = [ roll pitch yaw ];
endfunction
