function plotAltitudeControl(time_lp, lp_z, lp_vz, dist_z, dist_vz, 
    time_sp, sp_z, sp_vz, 
    time_distance, current_distance, 
    time_input_rc, input_rc, 
    time_air_data, air_alt_meter, 
    time_land_detect, land_detect,
    time_v_status, v_status,
    path)
  input_z = (input_rc(:,3)-1500)/500;  %rc roll channel set to 3
  h_alt = figure(4,'Position',[100,450,600,500]);
  clf(h_alt);
  subplot(211)
    plot(time_lp, -lp_z,'LineWidth',1.2);
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    ylim( [min(-lp_z)-1 max(-lp_z)+1]);
    grid on;
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Distance (m)");  title("Position Z");
    hold on;
      plot(time_sp, -sp_z, 'LineWidth',1.5);
      plot(time_distance, current_distance, 'LineWidth',1.5);
      plot(time_input_rc, input_z, 'LineWidth',1);
      takeoff = false;
      pos_x_touched_prev = 0;
      pos_x_mayLanded_prev = 0;
      pos = get(gca, "Position");   %Get plot position [x, y, width, height]
      for i=2:length(time_land_detect)
        for j=1:4
          if(land_detect(i,j)!=land_detect(i-1,j))
            pos_x = (time_land_detect(i)-time_lp(1))/(time_lp(length(time_lp)) - time_lp(1));
            x0 = pos(1) + pos_x * pos(3);
            y0 = pos(2);
            x1 = x0;
            y1 = pos(2)+pos(4);
            switch(j)
              case 1
                if(takeoff) msg = "Land"; takeoff = false; else msg = "Take Off"; takeoff = true; endif; 
                hgt = 0; 
              case 2 
                msg = "Falling"; hgt = 0.03;
              case 3 
                if( (pos_x - pos_x_touched_prev) < 0.04 ) msg = ""; 
                else msg = "Touched"; hgt = 0.05; endif;
                pos_x_touched_prev = pos_x; hgt = 0.05;
              case 4
                if( (pos_x - pos_x_mayLanded_prev) < 0.04 ) msg = "";
                else msg = "Landed?";  endif;
                pos_x_mayLanded_prev = pos_x; hgt = 0.08;
            endswitch
            annotation("line", [x0 x1], [y0 y1], "linestyle", "--");
            annotation("textbox", [x0 y0 + hgt 0.1 0.1],"string", msg, "backgroundcolor","w");
          endif
        endfor
      endfor
      pos_x_prev = 0;
      annotation("textbox", [pos(1) pos(2)+0.08 0.1 0.1],"string",getNavState(v_status(1,1)) , "color","b", "backgroundcolor","w");
      for i=2:length(time_v_status)
        if(v_status(i,1)!=v_status(i-1,1))
          pos_x = (time_v_status(i)-time_lp(1))/(time_lp(length(time_lp)) - time_lp(1));
          if( (pos_x - pos_x_prev) < 0.04) hgt = 0.03; else hgt = 0; endif;
          x0 = pos(1) + pos_x * pos(3);
          y0 = pos(2) + 0.08;
          x1 = x0;
          y1 = pos(2)+pos(4);
          msg = getNavState(v_status(i,1));
          annotation("line", [x0 x1], [y0 y1], "color","b");
          annotation("textbox", [x0 y0 + hgt 0.1 0.1],"string", msg, "color","b", "backgroundcolor","w");
          pos_x_prev = pos_x;
        endif
      endfor      
      [hleg1 hobj1] = legend("Local Z", "Setpoint Z", "Current Distance", "Throttle Input");
      set(hleg1,'position',[0.77 0.77 0.13 0.21])
    hold off;
  subplot(212)
    plot(time_lp, -lp_vz,'LineWidth',1.5);  
    xlabel("Time(sec)");  ylabel("Velocity (m/s)");  title("Velocity Z");
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    grid on;
    set (gca, "xminorgrid", "on");
    hold on;  
    plot(time_sp, -sp_vz,'LineWidth',1.5);
    plot(time_input_rc, input_z, 'LineWidth',1.5);
    legend("LP Vz", "Setpoint Vz", "Throttle");
    hold off;
  saveName = sprintf("%sAltitude_Control.png", path)
  saveas(h_alt,saveName);
endfunction
