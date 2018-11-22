function plotAttitudeControl(time_att, att_rpy_speed, att_q, time_att_sp, att_rpy_sp, time_input_rc, input_rc, path)
  input_roll = (input_rc(:,1)-1500)/500;   %rc Roll channel set to 1
  input_pitch = (input_rc(:,2)-1500)/500;  %rc Pitch channel set to 2
  input_yaw = (input_rc(:,4)-1500)/500;    %rc Yaw channel set to 4
  rpy = [];
  for i=1:length(att_q)
    rpy = [ rpy; quaternionToEuler(att_q(i,1), att_q(i,2), att_q(i,3), att_q(i,4)) ];
  endfor
  h_att = figure(1,'Position',[0,900,600,400]);
  clf(h_att);
  
  hAx1 = subplot(211);
  plot(time_att, rpy(:,1),'LineWidth',1.3);
  xlim( [ time_att(1) time_att(length(time_att)) ]);
  grid on;
  xlabel("Time(sec)");  ylabel("Angle");  title("Roll");
  hold on;
    plot(time_att_sp, att_rpy_sp(:,1)*180/pi, 'LineWidth',1.3);
    plot(time_input_rc, input_roll, 'LineWidth',1.2);
    [hleg1 hobj1] = legend("IMU", "Setpoint", "Input Roll",'location','eastoutside');
  hold off;
  %% capture handle to current figure and axis
  hFig = gcf;
  %% create a second transparent axis, as a copy of the first
  hAx2 = copyobj(hAx1,hFig);
  delete( get(hAx2,'Children') );
  set(hAx2, 'Color','none', 'Box','on', ...
      'XGrid','off', 'YGrid','off')
  set(hAx1, 'XColor',[0.7 0.7 0.7], 'YColor',[0.7 0.7 0.7], ...
      'XMinorGrid','on', 'YMinorGrid','on', 'MinorGridLineStyle','-', ...
      'XTickLabel',[], 'YTickLabel',[]);
  xlabel(hAx1, ''), ylabel(hAx1, ''), title(hAx1, '')
  
  hAx3 = subplot(212);
  plot(time_att, rpy(:,2),'LineWidth',1.3);
  xlim( [ time_att(1) time_att(length(time_att)) ]);
  grid on;
  xlabel("Time(sec)");  ylabel("Angle");  title("Pitch");
  hold on;
    plot(time_att_sp, att_rpy_sp(:,2)*180/pi, 'LineWidth',1.3);
    plot(time_input_rc, input_pitch, 'LineWidth',1.2);
    [hleg1 hobj1] = legend("IMU", "Setpoint", "Input Pitch" ,'location','eastoutside');
  hold off;
  %% capture handle to current figure and axis
  hFig2 = gcf();
  %% create a second transparent axis, as a copy of the first
  hAx4 = copyobj(hAx3, hFig2);
  delete( get(hAx4,'Children') )
  set(hAx4, 'Color','none', 'Box','on', ...
      'XGrid','off', 'YGrid','off')
  set(hAx3, 'XColor',[0.7 0.7 0.7], 'YColor',[0.7 0.7 0.7], ...
      'XMinorGrid','on', 'YMinorGrid','on', 'MinorGridLineStyle','-', ...
      'XTickLabel',[], 'YTickLabel',[]);
  xlabel(hAx3, ''), ylabel(hAx3, ''), title(hAx3, '')
  
  saveName = sprintf("%sAttitude_Control", path)
  print(h_att, saveName, "-dpdf","-color","-S800,1000");
  print(h_att, saveName, "-dpng","-color", "-r200");
  
  h_yaw = figure(2,'Position',[0,800,600,400]);
  clf(h_yaw);
  plot(time_att, rpy(:,3),'LineWidth',1.5);
  xlim( [ time_att(1) time_att(length(time_att)) ]);
  grid on;
  set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Heading");  title("Yaw");
  hold on;
    plot(time_att_sp, att_rpy_sp(:,3)*180/pi, 'LineWidth',1.5);
    plot(time_input_rc, input_yaw, 'LineWidth',1.2);
    [hleg1 hobj1] = legend("IMU", "Setpoint", "Input Yaw",'location','eastoutside');
  hold off;
  saveName = sprintf("%sAttitude_Yaw_Control", path)
  print(h_yaw, saveName, "-dpdf","-color","-S400,400");
  print(h_yaw, saveName, "-dpng","-color", "-r200");

endfunction
