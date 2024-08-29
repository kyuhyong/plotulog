function plotPositionControl(time_lp, lp_xyz, lp_Vxyz, 
    time_sp, sp_xyz, sp_Vxyz, 
    time_flow, flow_int_xy, 
    time_input_rc, input_rc, 
    time_v_status, v_status,
    time_att, att_q,
    path)  
  % Local pos NED has x towards North, y East and z Down. 
  input_x = (input_rc(:,1)-1500)/100;  %RC Roll channel set to 1 and Robot frame y is torward the Right
  input_y = (input_rc(:,2)-1500)/100;  %RC Pitch channel set to 2 and Robot frame x is towards the Front
  
  %% Draw plot for integral of optical flow data
  if(length(time_flow) > 1)
    flow_x = [0]; flow_y = [0];
    for i=2:length(time_flow)
      flow_x = [flow_x (flow_x(i-1)+(flow_int_xy(i,1)/(time_flow(i)-time_flow(i-1))))];
      flow_y = [flow_y (flow_y(i-1)+(flow_int_xy(i,2)/(time_flow(i)-time_flow(i-1))))];
    endfor
    h_flow = figure(5, 'Position',[650,900,600,400]);
    clf(h_flow);
    subplot(211)
      plot(time_flow, -(flow_x-1)/10, 'LineWidth',1.5);
      grid on;
      set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X (m)");  title("Optical flow integral (Body Frame X)");
      hold on;
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
  endif
  %% Draw plot for position x, y control
  h_xy = figure(6,'Position',[700,750,600,400]);
  clf(h_xy);
  subplot(211)
    plot(time_lp,lp_xyz(:,1), 'r-','LineWidth',1.5);
    grid on;
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X (m)");  title("Position X (To East)");
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);    
    hold on;
    plot(time_sp, sp_xyz(:,1), 'LineWidth',1.5);
    legend("Local pos", "Set Point",'location','eastoutside');
    %% Add flags for state change
    yl = ylim;
    flagYstep = (yl(2) - yl(1))/15;
    flagControlState(yl, flagYstep, time_v_status, v_status);
    hold off;
  subplot(212)
    plot(time_lp, lp_xyz(:,2), 'r-','LineWidth',1.5);  
    grid on;
    set (gca, "xminorgrid", "on"); xlabel("Time(sec)");  ylabel("Y (m)");  title("Position Y (To North)");
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    hold on;
    plot(time_sp, sp_xyz(:,2), 'LineWidth',1.5);
    legend("Local pos", "Set Point",'location','eastoutside');
    %% Add flags for state change
    yl = ylim;
    flagYstep = (yl(2) - yl(1))/15;
    flagControlState(yl, flagYstep, time_v_status, v_status);
    hold off;
  saveName = sprintf("%sPosition_Control", path)
  print(h_xy, saveName, "-dpdf","-color","-S400,800");
  print(h_xy, saveName, "-dpng","-color", "-r200");
  
  %% Draw plot for speed x, y control
  h_vxy = figure(7,'Position',[750,600,600,400]);
  clf(h_vxy);
  subplot(211)
    plot(time_lp,lp_Vxyz(:,1), 'LineWidth',1.5);
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    grid on;
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("X speed (m/s)");  title("Velocity X (To North)");
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    hold on;
    plot(time_sp, sp_Vxyz(:,1),'LineWidth',1);
    legend("Local pos", "Set Point",'location','eastoutside');
    %% Add flags for state change
    yl = ylim;
    flagYstep = (yl(2) - yl(1))/15;
    flagControlState(yl, flagYstep, time_v_status, v_status);
    hold off;
  subplot(212)
    plot(time_lp, lp_Vxyz(:,2), 'LineWidth',1.5);  
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    grid on;
    set (gca, "xminorgrid", "on"); xlabel("Time(sec)");  ylabel("Y speed (m/s)");  title("Velocity Y (To East)");
    xlim( [ time_lp(1) time_lp(length(time_lp)) ]);
    hold on;
    plot(time_sp, sp_Vxyz(:,2),'LineWidth',1);
    legend("Local pos", "Set Point",'location','eastoutside');
    %% Add flags for state change
    yl = ylim;
    flagYstep = (yl(2) - yl(1))/15;
    flagControlState(yl, flagYstep, time_v_status, v_status);
    hold off;
  saveName = sprintf("%sPosition_VelocityControl.png", path)
  print(h_vxy, saveName, "-dpdf","-color","-S400,800");
  print(h_vxy, saveName, "-dpng","-color", "-r200");
  
  %% Draw 3-D position estimation
  interval = time_lp(2)-time_lp(1);
  figure(8,'Position',[800,450,600,400]);
  h = plot3(lp_xyz(:,1), lp_xyz(:,2), lp_xyz(:,3), 'LineWidth', 1.5);
  hold on;
  % Plot unit vectors at the origin for the x, y, and z axes
  % Plot initial static unit vectors (optional)
  % X-axis unit vector (red)
  h_x = quiver3(0, 0, 0, 1, 0, 0, 'r', 'LineWidth', 2);
  % Y-axis unit vector (green)
  h_y = quiver3(0, 0, 0, 0, 1, 0, 'g', 'LineWidth', 2);
  % Z-axis unit vector (blue)
  h_z = quiver3(0, 0, 0, 0, 0, 1, 'b', 'LineWidth', 2);
  % Placeholder for the rotated unit vectors
  h_rot_x = quiver3(0, 0, 0, 0, 0, 0, 'r', 'LineWidth', 1.5); % Rotated X-axis vector
  h_rot_y = quiver3(0, 0, 0, 0, 0, 0, 'g', 'LineWidth', 1.5); % Rotated Y-axis vector
  h_rot_z = quiver3(0, 0, 0, 0, 0, 0, 'b', 'LineWidth', 1.5); % Rotated Z-axis vector

  grid minor;
  xlabel("X (m)");  ylabel("Y (m)"); zlabel("Height (m)"); title("Position Estimation X,Y,Z");
  for k=1:length(lp_xyz(:,1));
    set(h, 'XData', lp_xyz((1:k),1));
    set(h, 'YData', lp_xyz((1:k),2));
    set(h, 'ZData', -lp_xyz((1:k),3));
    % Rotate the unit vector using the quaternion att_q(k, :)
    r_x = rotate_vector_by_quaternion([2, 0, 0], att_q(k, :)); % Assuming rotation of X-axis unit vector
    r_y = rotate_vector_by_quaternion([0, 2, 0], att_q(k, :)); % Assuming rotation of X-axis unit vector
    r_z = rotate_vector_by_quaternion([0, 0, 2], att_q(k, :)); % Assuming rotation of X-axis unit vector
    
    % Update the quiver to show the rotated vector at the current position
    set(h_rot_x, 'XData', lp_xyz(k, 1));
    set(h_rot_x, 'YData', lp_xyz(k, 2));
    set(h_rot_x, 'ZData', -lp_xyz(k, 3));
    set(h_rot_x, 'UData', r_x(1));
    set(h_rot_x, 'VData', r_x(2));
    set(h_rot_x, 'WData', r_x(3));
    
    set(h_rot_y, 'XData', lp_xyz(k, 1));
    set(h_rot_y, 'YData', lp_xyz(k, 2));
    set(h_rot_y, 'ZData', -lp_xyz(k, 3));
    set(h_rot_y, 'UData', r_y(1));
    set(h_rot_y, 'VData', r_y(2));
    set(h_rot_y, 'WData', r_y(3));
    
    set(h_rot_z, 'XData', lp_xyz(k, 1));
    set(h_rot_z, 'YData', lp_xyz(k, 2));
    set(h_rot_z, 'ZData', -lp_xyz(k, 3));
    set(h_rot_z, 'UData', r_z(1));
    set(h_rot_z, 'VData', r_z(2));
    set(h_rot_z, 'WData', r_z(3));
    pause (0.01); % delay in seconds
    % alternatively could provide a velocity function
    % pause(sqrt(vx(k)^2+vy(k)^2+vz(k)^2));  
  endfor
endfunction



