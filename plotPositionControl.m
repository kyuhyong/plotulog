function plotPositionControl(time_lp, lp_xyz, lp_Vxyz, time_sp, sp_xyz, sp_Vxyz, time_flow, flow_int_xy, time_input_rc, input_rc, path)  
  % Local pos NED has x towards North, y East and z Down. 
  input_x = (input_rc(:,1)-1500)/100;  %RC Roll channel set to 1 and Robot frame y is torward the Right
  input_y = (input_rc(:,2)-1500)/100;  %RC Pitch channel set to 2 and Robot frame x is towards the Front
  flow_x = [0]; flow_y = [0];
  for i=2:length(time_flow)
    flow_x = [flow_x (flow_x(i-1)+(flow_int_xy(i,1)/(time_flow(i)-time_flow(i-1))))];
    flow_y = [flow_y (flow_y(i-1)+(flow_int_xy(i,2)/(time_flow(i)-time_flow(i-1))))];
  endfor
  h_flow = figure(5, 'Position',[650,900,600,400]);
  subplot(211)
    plot(time_flow, -(flow_x-1)/10, 'LineWidth',1.5);
    grid on;
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X (m)");  title("Optical flow integral (Body Frame X)");
    hold on;
    %plot(time_lp, lp_xyz(:,1));
    plot(time_input_rc, input_x/5, 'LineWidth',1.2);
    legend("Flow int X", "RC Input Roll");
    hold off;
  subplot(212)
    plot(time_flow, -(flow_y-1)/10, 'LineWidth',1.5);
    grid on;
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Y (m)");  title("Optical flow integral (Body Frame Y)");
    hold on;
    plot(time_input_rc, input_y/5, 'LineWidth',1.2);
    legend("Flow int Y", "RC Input Pitch");
    hold off;
  
  h_xy = figure(6,'Position',[700,750,600,400]);
  subplot(211)
    plot(time_lp,lp_xyz(:,1), 'r-','LineWidth',1.5);
    grid on;
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X (m)");  title("Position X (To East)");
    hold on;
    plot(time_sp, sp_xyz(:,1), 'LineWidth',1.5);
    legend("Local pos", "Set Point");
    hold off;
  subplot(212)
    plot(time_lp, lp_xyz(:,2), 'r-','LineWidth',1.5);  
    grid on;
    set (gca, "xminorgrid", "on"); xlabel("Time(sec)");  ylabel("Y (m)");  title("Position Y (To North)");
    hold on;
    plot(time_sp, sp_xyz(:,2), 'LineWidth',1.5);
    legend("Local pos", "Set Point");
    hold off;
  saveName = sprintf("%sPosition_Control.png", path)
  saveas(h_xy,saveName);
  
  h_vxy = figure(7,'Position',[750,600,600,400]);
  subplot(211)
    plot(time_lp,lp_Vxyz(:,1), 'LineWidth',1.5);
    grid on;
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X speed (m/s)");  title("Velocity X (To North)");
    hold on;
    plot(time_sp, sp_Vxyz(:,1),'LineWidth',1);
    legend("Local pos", "Set Point");
    hold off;
  subplot(212)
    plot(time_lp, lp_Vxyz(:,2), 'LineWidth',1.5);  
    grid on;
    set (gca, "xminorgrid", "on"); xlabel("Time(sec)");  ylabel("Y speed (m/s)");  title("Velocity Y (To East)");
    hold on;
    plot(time_sp, sp_Vxyz(:,2),'LineWidth',1);
    legend("Local pos", "Set Point");
    hold off;
  saveName = sprintf("%sPosition_VelocityControl.png", path)
  saveas(h_vxy,saveName);
  
  interval = time_lp(2)-time_lp(1);
  figure(8,'Position',[800,450,600,400]);
  h = plot3(lp_xyz(:,1), lp_xyz(:,2), -lp_xyz(:,3), 'LineWidth', 1.5);
  grid minor;
  xlabel("X (m)");  ylabel("Y (m)"); zlabel("Height (m)"); title("Position Estimation X,Y,Z");
  for k=1:length(lp_xyz(:,1));
    set(h, 'XData', lp_xyz((1:k),1));
    set(h, 'YData', lp_xyz((1:k),2));
    set(h, 'ZData', -lp_xyz((1:k),3));
    pause (0.01); % delay in seconds
    % alternatively could provide a velocity function
    % pause(sqrt(vx(k)^2+vy(k)^2+vz(k)^2));  
  endfor
endfunction
