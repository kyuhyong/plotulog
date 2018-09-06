function plotPositionControl(time_lp, lp_x, lp_y, lp_z, lp_vx, lp_vy, time_sp, sp_x, sp_y, sp_vx, sp_vy, time_flow, flow_int_x, flow_int_y, time_input_rc, input_rc, path)  
  % Local pos NED has x towards North, y East and z Down. 
  input_y = (input_rc(:,1)-1500)/100;  %RC Roll channel set to 1 and Robot frame y is torward the Right
  input_x = (input_rc(:,2)-1500)/100;  %RC Pitch channel set to 2 and Robot frame x is towards the Front
  flow_x = [0]; flow_y = [0];
  for i=2:length(time_flow)
    flow_x = [flow_x flow_x(i-1)+( flow_int_x(i) / (time_flow(i) - time_flow(i-1)) )];
    flow_y = [flow_y flow_y(i-1)+( flow_int_y(i) / (time_flow(i) - time_flow(i-1)) )];
  endfor
  h_flow = figure(9, 'Position',[200,600,800,400]);
  subplot(211)
  plot(time_flow, (flow_x-1)/10);
  grid on;
  set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X (m)");  title("Position X Integral");
  hold on;
  plot(time_lp, lp_x);
  legend("Integral of Flow intX(Vehicle Frame)", "Pos Estimation(NED)");
  hold off;
  subplot(212)
  plot(time_flow, (flow_y-1)/10);
  grid on;
  set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Y (m)");  title("Position Y Integral");
  hold on;
  plot(time_lp, lp_y);
  legend("Integral of Flow intY(Vehicle Frame)", "Pos Estimation(NED)");
  hold off;
  
  h_xy = figure(4,'Position',[0,600,800,400]);
  subplot(211)
  plot(time_lp,lp_x, 'r-','LineWidth',1.5);
  grid on;
  set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X (m)");  title("Position X (To North)");
  hold on;
  plot(time_sp, sp_x, 'LineWidth',1.5);
  plot(time_flow, flow_int_x);
  plot(time_input_rc, input_x/5, 'LineWidth',1.5);
  legend("Local pos", "Set Point", "Flow Int", "RC Input Pitch");
  hold off;
  subplot(212)
  plot(time_lp, lp_y, 'r-','LineWidth',1.5);  
  grid on;
  set (gca, "xminorgrid", "on"); xlabel("Time(sec)");  ylabel("Y (m)");  title("Position Y (To East)");
  hold on;
  plot(time_sp, sp_y, 'LineWidth',1.5);
  plot(time_flow, flow_int_y);
  plot(time_input_rc, input_y/5, 'LineWidth',1.5);
  legend("Local pos", "Set Point", "Flow Int", "RC Input Roll");
  hold off;
  saveName = sprintf("%sPosition_Control.png", path)
  saveas(h_xy,saveName);
  
  h_vxy = figure(5,'Position',[0,300,800,400]);
  subplot(211)
  plot(time_lp,lp_vx, 'LineWidth',1.5);
  grid on;
  set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X speed (m/s)");  title("Velocity X (To North)");
  hold on;
  plot(time_sp, sp_vx,'LineWidth',1);
  plot(time_input_rc, input_x/10,'LineWidth',1.5);
  legend("Local pos", "Set Point", "RC Input Roll");
  hold off;
  subplot(212)
  plot(time_lp, lp_vy, 'LineWidth',1.5);  
  grid on;
  set (gca, "xminorgrid", "on"); xlabel("Time(sec)");  ylabel("Y speed (m/s)");  title("Velocity Y (To East)");
  hold on;
  plot(time_sp, sp_vy,'LineWidth',1);
  plot(time_input_rc, input_y/10,'LineWidth',1.5);
  legend("Local pos", "Set Point", "RC Input Pitch");
  hold off;
  saveName = sprintf("%sPosition_VelocityControl.png", path)
  saveas(h_vxy,saveName);
  
  interval = time_lp(2)-time_lp(1)
  figure(6,'Position',[800,1000,800,500]);
  %comet3(lp_x, lp_y, lp_z, interval)
  h = plot3(lp_x, lp_y, lp_z, 'LineWidth', 1.5);
  %axis([min(lp_x), max(lp_x), min(lp_y), max(lp_y), min(lp_z), max(lp_z)]);
  grid minor;
  xlabel("X (m)");  ylabel("Y (m)"); zlabel("Height (m)"); title("Position Estimation X,Y,Z");
  for k=1:length(lp_x);
    set(h, 'XData', lp_x(1:k));
    set(h, 'YData', lp_y(1:k));
    set(h, 'ZData', lp_z(1:k));
    pause (0.01); % delay in seconds
    % alternatively could provide a velocity function
    % pause(sqrt(vx(k)^2+vy(k)^2+vz(k)^2));  
  endfor
endfunction
