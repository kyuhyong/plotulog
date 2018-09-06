function plotUlogs(varargin)
  input_ulogFile = false;
  input_folderName = false;
  argnum = length(varargin);
  arg1 = varargin{1};
  % Check if first input argument is .ulg file
  try
    if(strsplit(arg1,'.'){2} == "ulg")
      ulogFileName = varargin{1}
      input_ulogNum = strsplit(strsplit(ulogFileName,'.'){1}, "log"){2};
      % Check if descriptive folder name supplied
      if(argnum>1) 
        arg2 = varargin{2};
        folderName = sprintf("%s_%s", input_ulogNum, arg2)
      else
        folderName = input_ulogNum
      endif
      if(!checkFile(ulogFileName)) return; endif;
      cmd = sprintf("mkdir %s", folderName);
      if(system(cmd)==0)
        cmd = sprintf("ulog2csv %s -o %s", ulogFileName, folderName);
        disp("Covnerting ulg to csv..."); system(cmd);
      else
        disp("Folder exists")
      endif
      folderName = sprintf("%s/",folderName);
    endif
  catch
    % First argument is folder name
    folderName = arg1;
  end_try_catch
  % Split folder name with leading number for searching file name
  if(strfind(folderName,'_')>0)
    fnum = strsplit(folderName,'_'){1}
  else
    fnum = strsplit(folderName,'/'){1}
  endif
  fnames = dir(folderName);
  fname_att = sprintf("%slog%s_vehicle_attitude_0.csv",folderName, fnum)
  fname_att_sp = sprintf("%slog%s_vehicle_attitude_setpoint_0.csv",folderName, fnum)
  fname_lp = sprintf("%slog%s_vehicle_local_position_0.csv",folderName, fnum)
  fname_lp_sp = sprintf("%slog%s_vehicle_local_position_setpoint_0.csv",folderName, fnum)
  fname_flow = sprintf("%slog%s_optical_flow_0.csv",folderName, fnum)
  fname_sens = sprintf("%slog%s_sensor_combined_0.csv",folderName, fnum)
  fname_debug_vect = sprintf("%slog%s_debug_vect_0.csv",folderName, fnum)
  fname_dist = sprintf("%slog%s_distance_sensor_0.csv",folderName, fnum)
  fname_input_rc = sprintf("%slog%s_input_rc_0.csv",folderName, fnum)
  %% Check files
  data_att_avail = true; data_att_sp_avail = true; data_lp_avail = true; data_lp_sp_avail = true; data_dbg_vect_avail = true; data_flow_avail = true; data_sensor_avail = true; data_distance_avail = true; data_input_rc_avail = true;
  if(!checkFile(fname_att)) data_att_avail = false; endif;
  if(!checkFile(fname_att_sp)) data_att_sp_avail = false; endif;
  if(!checkFile(fname_lp)) data_lp_avail = false; endif;
  if(!checkFile(fname_lp_sp)) data_lp_sp_avail = false; endif;
  if(!checkFile(fname_flow)) data_flow_avail = false; endif;
  if(!checkFile(fname_sens)) data_sensor_avail = false; endif;
  if(!checkFile(fname_debug_vect)) data_dbg_vect_avail = false; endif;
  if(!checkFile(fname_dist)) data_distance_avail = fasle; endif;
  if(!checkFile(fname_input_rc)) data_input_rc_avail = fasle; endif;
  %% If file is available, read data from the file. otherwise set data as zero
  if(data_att_avail)
    data_att = dlmread(fname_att,',',1,0);  [row1 col1] = size(data_att); 
    time_att = data_att(:,1)/1000000; att_rollRate = data_att(:,2); att_pitchRate = data_att(:,3);  att_yawRate = data_att(:,4); 
  else time_att = 0; att_rollRate = 0; att_pitchRate = 0; att_yawRate = 0;
  endif
  if(data_att_sp_avail)
    data_att_sp = dlmread(fname_att_sp,',',1,0);  [row1 col1] = size(data_att_sp); 
    time_att_sp = data_att_sp(:,1)/1000000; att_sp_roll = data_att_sp(:,2); att_sp_pitch = data_att_sp(:,3);  att_sp_yawRate = data_att_sp(:,4); att_sp_thrust = data_att_sp(:,10);
  else time_att_sp = 0; att_sp_roll = 0; att_sp_pitch = 0; att_sp_yawRate = 0; att_sp_thrust = 0;
  endif
  if(data_lp_avail) 
    data_lp = dlmread(fname_lp,',',1,0);  [row1 col1] = size(data_lp); 
    time_lp = data_lp(:,1)/1000000; lp_x = data_lp(:,5); lp_y = data_lp(:,6);  lp_z = - data_lp(:,7); 
    lp_vx = data_lp(:,11); lp_vy = data_lp(:,12); lp_vz = -data_lp(:,13);  
    lp_yaw = data_lp(:,21); dist_z = data_lp(:,23);  dist_vz = data_lp(:,24);
  else 
    time_lp = 0; lp_x = 0; lp_y = 0; lp_z = 0; lp_vx = 0; lp_vy = 0; lp_vz = 0;
  endif;
  if(data_lp_sp_avail) 
    data_lp_sp = dlmread(fname_lp_sp,',',1,0);  [row2 col2] = size(data_lp_sp);  
    time_lp_sp = data_lp_sp(:,1)/1000000; lp_sp_x = data_lp_sp(:,2); lp_sp_y = data_lp_sp(:,3); lp_sp_z = - data_lp_sp(:,4);  
    lp_sp_vx = data_lp_sp(:,7); lp_sp_vy = data_lp_sp(:,8); lp_sp_vz = -data_lp_sp(:,9);
  else time_lp_sp = 0; lp_sp_x = 0; lp_sp_y = 0; lp_sp_z = 0; lp_sp_vx = 0; lp_sp_vy = 0; lp_sp_vz = 0;
  endif;
  data_sens = dlmread(fname_sens,',',1,0);  [row4 col4] = size(data_sens);
  if(data_dbg_vect_avail) 
    data_dbg_vect = dlmread(fname_debug_vect,',',1,0);  [row5 col5] = size(data_dbg_vect); 
    time_dbg_vect = data_dbg_vect(:,1)/1000000; dbg_vect_x = data_dbg_vect(:,3); dbg_vect_y = data_dbg_vect(:,4); dbg_vect_z = data_dbg_vect(:,5);
  else time_dbg_vect = 0; dbg_vect_x = 0; dbg_vect_y = 0; dbg_vect_z = 0;
  endif;
  if(data_flow_avail)
    data_flow = dlmread(fname_flow,',',1,0);  [row3 col3] = size(data_flow);
    time_flow = data_flow(:,1)/1000000; flow_x_int = data_flow(:,2); flow_y_int = data_flow(:,3);
  else flow_x_int = 0; flow_y_int = 0;
  endif;
  if(data_sensor_avail)
    time_sensor = data_sens(:,1)/1000000; gyro_x=data_sens(:,2);gyro_y=data_sens(:,3);gyro_z=data_sens(:,4); acc_x = data_sens(:, 7);acc_y = data_sens(:, 8);acc_z = data_sens(:, 9);
  else time_sensor = 0; gyro_x = 0; gyro_y = 0; gyro_z = 0; acc_x = 0; acc_y = 0; acc_z = 0;
  endif
  if(data_distance_avail) 
    data_distance = dlmread(fname_dist,',',1,0);  [row6 col6] = size(data_distance); 
    time_dist = data_distance(:,1)/1000000; current_distance = data_distance(:,4);
  else time_dist = 0; current_distance = 0;
  endif;
  if(data_input_rc_avail)
    data_input_rc = dlmread(fname_input_rc,',',1,0);  [row7 col7] = size(data_input_rc); 
    time_input_rc = data_input_rc(:,1)/1000000; input_rc = [data_input_rc(:,8) data_input_rc(:,9) data_input_rc(:,10) data_input_rc(:,11) data_input_rc(:,12)];
  else time_input_rc = 0; input_rc = 0;
  endif;
  %% Plot for Z axis data
  plotAltitudeControl(time_lp, lp_z, dist_z, dist_vz, lp_vz, time_lp_sp, lp_sp_z, lp_sp_vz, time_dist, current_distance, time_input_rc, input_rc, folderName);
  %% Plot raw sensor data
  plotSensorData(time_sensor, gyro_x, gyro_y, gyro_z, acc_x, acc_y, acc_z, folderName);
  %% Plot for x, y, z axis data
  plotPositionControl(time_lp, lp_x, lp_y, lp_z, lp_vx, lp_vy, time_lp_sp, lp_sp_x, lp_sp_y, lp_sp_vx, lp_sp_vy, time_flow, flow_x_int, flow_y_int, time_input_rc, input_rc, folderName);
  
endfunction
