function plotAltitudeControl(time_lp, lp_z, lp_vz, dist_z, dist_vz, 
    time_sp, sp_z, sp_vz, 
    time_distance, current_distance, 
    time_input_rc, input_rc, 
    time_air_data, air_alt_meter, 
    time_land_detect, land_detect,
    time_v_status, v_status,
    path)
  input_z = (input_rc(:,3)-1500)/500;  %rc throttle channel set to 3
  
  %% Draw plot for vertical (z axis) control
  h_alt = figure(4,'Position',[100,450,600,500]);
  clf(h_alt);
  %% Draw plot for vertical position control
  subplot(211)
    plot(time_lp, -lp_z,'LineWidth',1.2);
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    grid on;
    set (gca, "xminorgrid", "on");set (gca, "yminorgrid", "on");
    set(gca, 'XAxisLocation', 'origin')
    xlabel("Time(sec)");  ylabel("Distance (m)");  title("Position Z");
    hold on;
      plot(time_sp, -sp_z, 'LineWidth',1.5);
      plot(time_distance, current_distance, 'LineWidth',1.5);
      plot(time_input_rc, input_z, 'LineWidth',1);
      plot( [time_lp(1); time_lp(length(time_lp))],[0; 0], "LineWidth", 1.3, "color", "black");
      [hleg1 hobj1] = legend("Local Z", "Setpoint Z", "Current Distance", "Throttle Input");
      set(hleg1,'position',[0.77 0.77 0.13 0.21])
      %% Add flags for land detect change
      yl = ylim;
      flagYstep = (yl(2) - yl(1))/15;
      flagLandState(yl, flagYstep, time_land_detect, land_detect);
      %% Add flags for state change
      flagControlState(yl, flagYstep, time_v_status, v_status);
    hold off;
  %% Draw plot for vertical speed control
  subplot(212)
    plot(time_lp, -lp_vz,'LineWidth',1.5);  
    xlabel("Time(sec)");  ylabel("Velocity (m/s)");  title("Velocity Z");
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    grid on;
    set (gca, "xminorgrid", "on");set (gca, "yminorgrid", "on");
    hold on;  
    plot(time_sp, -sp_vz,'LineWidth',1.5);
    plot(time_input_rc, input_z, 'LineWidth',1.5);
    plot( [time_lp(1); time_lp(length(time_lp))],[0; 0], "LineWidth", 1.2, "color", "black");
    legend("LP Vz", "Setpoint Vz", "Throttle");
    %% Add flags for state change
    yl = ylim;
    flagYstep = (yl(2) - yl(1))/15;
    flagControlState(yl, flagYstep, time_v_status, v_status);
    hold off;
  saveName = sprintf("%sAltitude_Control.png", path)
  saveas(h_alt,saveName);
endfunction
