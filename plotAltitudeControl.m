function plotAltitudeControl(time_lp, lp_z, lp_vz, dist_z, dist_vz, 
    time_sp, sp_z, sp_vz, 
    time_distance, current_distance, 
    time_input_rc, input_rc, 
    time_air_data, air_alt_meter, 
    time_land_detect, land_detect,
    time_v_status, v_status,
    time_thrust_sp, thrust_sp,
    path)
  input_z = (input_rc(:,3)-1500)/500;  %rc throttle channel set to 3
  
  %% Draw plot for vertical (z axis) control
  h_alt = figure(4,'Position',[100,450,600,500]);
  clf(h_alt);
  %% Draw plot for vertical position control
  hAx1 = subplot(211);
    plot(time_lp, -lp_z,'LineWidth',1.2);
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    grid on;
    set(gca, 'XAxisLocation', 'origin')
    xlabel("Time(sec)");  ylabel("Height (m)");  title("Position Z");
    hold on;
      plot(time_sp, -sp_z, 'LineWidth',1.5);
      plot(time_distance, current_distance, 'LineWidth',1.5);
      plot(time_input_rc, input_z, 'LineWidth',1);
      plot( [time_lp(1); time_lp(length(time_lp))],[0; 0], "LineWidth", 1.3, "color", "black");
      [hleg1 hobj1] = legend("Local Z", "Setpoint Z", "Sonar", "RC Throttle", 'location','eastoutside');
      set(hleg1, "fontsize",12);
      %% Add flags for land detect change
      yl = ylim;
      flagYstep = (yl(2) - yl(1))/15;
      flagLandState(yl, flagYstep, time_land_detect, land_detect);
      %% Add flags for state change
      flagControlState(yl, flagYstep, time_v_status, v_status);
    hold off;
    %% capture handle to current figure and axis
    hFig = gcf;
    %% create a second transparent axis, as a copy of the first
    hAx2 = copyobj(hAx1,hFig);
    delete( get(hAx2,'Children') )
    set(hAx2, 'Color','none', 'Box','on', ...
        'XGrid','off', 'YGrid','off')
    set(hAx1, 'XColor',[0.7 0.7 0.7], 'YColor',[0.7 0.7 0.7], ...
        'XMinorGrid','on', 'YMinorGrid','on', 'MinorGridLineStyle','-', ...
        'XTickLabel',[], 'YTickLabel',[]);
    xlabel(hAx1, ''), ylabel(hAx1, ''), title(hAx1, '')
  %% Draw plot for vertical speed control
  hAx3 =subplot(212);
    plot(time_lp, -lp_vz,'LineWidth',1.5);  
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    grid on;
    set(gca, 'XAxisLocation', 'origin')
    xlabel("Time(sec)");  ylabel("Velocity (m/s)");  title("Velocity Z");
    %set (gca, "xminorgrid", "on", "yminorgrid", "on");
    hold on;  
      plot(time_sp, -sp_vz,'LineWidth',1.5);
      plot(time_input_rc, input_z, 'LineWidth',1.5);
      plot(time_thrust_sp, -thrust_sp, 'LineWidth', 1.5);
      plot( [time_lp(1); time_lp(length(time_lp))],[0; 0], "LineWidth", 1.2, "color", "black");
      [hleg1 hobj1] = legend("LP Vz", "Setpoint Vz", "Throttle", "Thrust Set Point",'location','eastoutside');
      set(hleg1, "fontsize",12);
      %% Add flags for state change
      yl = ylim;
      flagYstep = (yl(2) - yl(1))/15;
      flagControlState(yl, flagYstep, time_v_status, v_status);
    hold off;
    %% capture handle to current figure and axis
    hFig2 = gcf();
    %% create a second transparent axis, as a copy of the first
    hAx4 = copyobj(hAx3, hFig2);
    delete( get(hAx4,'Children') );
    set(hAx4, 'Color','none', 'Box','on', ...
        'XGrid','off', 'YGrid','off')
    set(hAx3, 'XColor',[0.7 0.7 0.7], 'YColor',[0.7 0.7 0.7], ...
        'XMinorGrid','on', 'YMinorGrid','on', 'MinorGridLineStyle','-', ...
        'XTickLabel',[], 'YTickLabel',[]);
    xlabel(hAx3, ''), ylabel(hAx3, ''), title(hAx3, '')
    
  saveName = sprintf("%sAltitude_Control", path)
  print(h_alt, saveName, "-dpdf","-color","-S800,1000");
  print(h_alt, saveName, "-dpng","-color", "-r200");
endfunction
