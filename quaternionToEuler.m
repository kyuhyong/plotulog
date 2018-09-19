function euler = quaternionToEuler(q0, q1, q2, q3)
% Inputs:
%    q0, q1, q2, q3 : quaternion representation of attitude
%
% Example: 
%    [roll pitch yaw] = quaternionToEuler(q0, q1, q2, q3)
%
% See also: plotAttitudeControl
% References: 
%     https://en.wikipedia.org/wiki/Conversion_between_quaternions_and_Euler_angles
%     https://stackoverflow.com/questions/5782658/extracting-yaw-from-a-quaternion
% Author: Kyuhyong You
% Website: https://github.com/kyuhyong/plotulog
% Sep 2018; Last revision: 19-Sep-2018
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
