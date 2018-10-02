function plotAltitudeControl(time_lp, lp_z, lp_vz, dist_z, dist_vz, 
    time_sp, sp_z, sp_vz, 
    time_distance, current_distance, 
    time_input_rc, input_rc, 
    time_air_data, air_alt_meter, 
    time_land_detect, land_detect,
    time_v_status, v_status,
    path)
  input_z = (input_rc(:,3)-1500)/500;  %rc roll channel set to 3
  
  %% Draw plot for vertical (z axis) control
  h_alt = figure(4,'Position',[100,450,600,500]);
  clf(h_alt);
  %% Draw plot for vertical position control
  subplot(211)
    plot(time_lp, -lp_z,'LineWidth',1.2);
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    plotYmin = min(-lp_z)-1;
    plotYmax = max(-lp_z)+1;
    plotYstep = (plotYmax - plotYmin)/15;
    ylim( [plotYmin plotYmax]);
    grid on;
    set (gca, "xminorgrid", "on");set (gca, "yminorgrid", "on");
    set(gca, 'XAxisLocation', 'origin')
    xlabel("Time(sec)");  ylabel("Distance (m)");  title("Position Z");
    hold on;
      plot(time_sp, -sp_z, 'LineWidth',1.5);
      plot(time_distance, current_distance, 'LineWidth',1.5);
      plot(time_input_rc, input_z, 'LineWidth',1);
      plot( [time_lp(1); time_lp(length(time_lp))],[0; 0], "LineWidth", 1.3, "color", "black");
      takeoff = false;
      pos_x_touched_prev = 0;
      pos_x_mayLanded_prev = 0;
      for i=2:length(time_land_detect)
        for j=1:4
          if(land_detect(i,j)!=land_detect(i-1,j))
            pos_x = time_land_detect(i);
            n=1;
            switch(j)
              case 1
                if(takeoff) msg = "Land"; takeoff = false; 
                else msg = sprintf("Take Off @%.2f",time_land_detect(i)); takeoff = true; endif; 
                n = 1; 
              case 2 
                msg = "Falling"; n=3;
              case 3 
                if( (pos_x - pos_x_touched_prev) < 1 ) msg = ""; 
                else msg = "Touched"; n=3; endif;
                pos_x_touched_prev = pos_x;
              case 4
                if( (pos_x - pos_x_mayLanded_prev) < 1 ) msg = "";
                else msg = "Landed?";  endif;
                pos_x_mayLanded_prev = pos_x; n=2;
            endswitch
            plot([pos_x; pos_x],[plotYmin; plotYmax], "color", "r", "LineWidth", 1.3, "linestyle", "-.");
            text(pos_x, plotYmin+plotYstep*n, msg, 'FontSize',12);
          endif
        endfor
      endfor
      pos_x_prev = 0;
      plot([time_v_status(1); time_v_status(1)],[plotYmin; plotYmax], "color", "b", "LineWidth", 1.3, "linestyle", "--");
      text(time_v_status(1), plotYmax-plotYstep, getNavState(v_status(1,1)), 'FontSize',12);
      for i=2:length(time_v_status)
        if( v_status(i,1) != v_status(i-1,1) )
          pos_x = time_v_status(i);
          if( (pos_x - pos_x_prev) < 1) n=2; else n=1; endif;
          msg = getNavState(v_status(i,1));
          plot([pos_x; pos_x],[plotYmin; plotYmax], "color", "b", "LineWidth", 1.3, "linestyle", "--");
          text(pos_x, plotYmax-plotYstep*n, msg, 'FontSize',12);
          pos_x_prev = pos_x;
        endif
      endfor      
      [hleg1 hobj1] = legend("Local Z", "Setpoint Z", "Current Distance", "Throttle Input");
      set(hleg1,'position',[0.77 0.77 0.13 0.21])
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
    hold off;
  saveName = sprintf("%sAltitude_Control.png", path)
  saveas(h_alt,saveName);
endfunction
