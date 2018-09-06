function plotAltitudeControl(time_lp, lp_z, dist_z, dist_vz, lp_vz, time_sp, sp_z,  sp_vz, time_distance, current_distance, time_input_rc, input_rc, path)
  input_z = (input_rc(:,3)-1500)/100;  %rc roll channel set to 3
  
  h_alt = figure(1,'Position',[0,1000,800,400]);
  subplot(211)
  plot(time_lp, lp_z,'LineWidth',1.2);
  xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
  ylim( [min(lp_z) 2.5]);
  grid on;
  set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Distance (m)");  title("Position Z");
  hold on;
  plot(time_sp, sp_z, 'LineWidth',1.5);
  plot(time_distance, current_distance, 'LineWidth',1.5);
  plot(time_input_rc, input_z, 'LineWidth',1);
  legend("Local Z", "Setpoint Z", "Current Distance", "Throttle Input");
  %legend("Local Z", "Setpoint Z", "Current Distance", "E Integral", "Debug", "Throttle Input");
  hold off;
  subplot(212)
  plot(time_lp, lp_vz,'LineWidth',1.5);  
  xlabel("Time(sec)");  ylabel("Velocity (m/s)");  title("Velocity Z");
  xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
  grid on;
  set (gca, "xminorgrid", "on");
  hold on;  
  plot(time_sp, sp_vz,'LineWidth',1.5);
  plot(time_lp, dist_vz);
  plot(time_input_rc, input_z/10, 'LineWidth',1.5);
  legend("LP Vz", "Setpoint Vz", "LP Sonar Rate", "Throttle");
  hold off;
  saveName = sprintf("%sAltitude_Control.png", path)
  saveas(h_alt,saveName);
endfunction
