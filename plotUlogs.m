function plotUlogs(varargin)
% Inputs:
%    arg1 - File name of .ulog file or Folder name of already created csv files location
%    arg2 - Folder name description
%
% Example: 
%    plotUlogs("log001.ulg","Test1")
%    plotUlogs("001_Test1\")
%
% Other m-files required: checkFile.m, findMax.m
% See also: plotAttitudeControl, plotAltitudeControl, plotPositionControl, plotPower, plotSensorData

% Author: Kyuhyong You
% Website: https://github.com/kyuhyong/plotulog
% Sep 2018; Last revision: 12-Sep-2018

%------------- BEGIN CODE --------------
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
    fnum = strsplit(folderName,'_'){1};
  else
    fnum = strsplit(folderName,'/'){1};
  endif
  fnames = dir(folderName);
  fname_att = sprintf("%slog%s_vehicle_attitude_0.csv",folderName, fnum);
  fname_att_sp = sprintf("%slog%s_vehicle_attitude_setpoint_0.csv",folderName, fnum);
  fname_lp = sprintf("%slog%s_vehicle_local_position_0.csv",folderName, fnum);
  fname_lp_sp = sprintf("%slog%s_vehicle_local_position_setpoint_0.csv",folderName, fnum);
  fname_flow = sprintf("%slog%s_optical_flow_0.csv",folderName, fnum);
  fname_sens = sprintf("%slog%s_sensor_combined_0.csv",folderName, fnum);
  fname_debug_vect = sprintf("%slog%s_debug_vect_0.csv",folderName, fnum);
  fname_dist = sprintf("%slog%s_distance_sensor_0.csv",folderName, fnum);
  fname_input_rc = sprintf("%slog%s_input_rc_0.csv",folderName, fnum);
  fname_power_sys = sprintf("%slog%s_system_power_0.csv",folderName, fnum);
  fname_batt_sts = sprintf("%slog%s_battery_status_0.csv",folderName, fnum);
  
  %% Check files
  data_att_avail = true; data_att_sp_avail = true; data_lp_avail = true; data_lp_sp_avail = true; data_dbg_vect_avail = true; data_flow_avail = true; data_sensor_avail = true; data_distance_avail = true; data_input_rc_avail = true;
  data_pwr_sys_avail = true; data_batt_sts_avail = true;
  if(!checkFile(fname_att)) data_att_avail = false; endif;
  if(!checkFile(fname_att_sp)) data_att_sp_avail = false; endif;
  if(!checkFile(fname_lp)) data_lp_avail = false; endif;
  if(!checkFile(fname_lp_sp)) data_lp_sp_avail = false; endif;
  if(!checkFile(fname_flow)) data_flow_avail = false; endif;
  if(!checkFile(fname_sens)) data_sensor_avail = false; endif;
  if(!checkFile(fname_debug_vect)) data_dbg_vect_avail = false; endif;
  if(!checkFile(fname_dist)) data_distance_avail = false; endif;
  if(!checkFile(fname_input_rc)) data_input_rc_avail = false; endif;
  if(!checkFile(fname_power_sys)) data_pwr_sys_avail = false; endif;
  if(!checkFile(fname_batt_sts)) data_batt_sts_avail = false; endif;
  
  %% If file is available, read data from the file. otherwise set data as zero
  if(data_att_avail)
    data_att = dlmread(fname_att,',',1,0);
    time_att = data_att(:,1)/1000000; 
    att_rpy = [ data_att(:,2) data_att(:,3) data_att(:,4) ]; 
  else time_att = 0; att_rpy = [0 0 0];
  endif
  if(data_att_sp_avail)
    data_att_sp = dlmread(fname_att_sp,',',1,0);
    time_att_sp = data_att_sp(:,1)/1000000; 
    att_rpy_sp = [ data_att_sp(:,2) data_att_sp(:,3) data_att_sp(:,4) ]; 
    att_sp_thrust = data_att_sp(:,10);
  else time_att_sp = 0; att_rpy_sp = [0 0 0]; att_sp_thrust = 0;
  endif
  if(data_lp_avail) 
    data_lp = dlmread(fname_lp,',',1,0);
    time_lp = data_lp(:,1)/1000000; 
    lp_xyz =  [ data_lp(:,5)  data_lp(:,6)  data_lp(:,7) ]; 
    lp_Vxyz = [ data_lp(:,11) data_lp(:,12) data_lp(:,13)];
    lp_yaw = data_lp(:,21); dist_z = data_lp(:,23);  dist_vz = data_lp(:,24);
  else 
    time_lp = 0; lp_xyz = [0 0 0]; lp_Vxyz = [0 0 0]; lp_yaw = 0; dist_vz = 0; dist_z = 0;
  endif;
  if(data_lp_sp_avail) 
    data_lp_sp = dlmread(fname_lp_sp,',',1,0);
    time_lp_sp = data_lp_sp(:,1)/1000000; 
    lp_sp_xyz  = [ data_lp_sp(:,2) data_lp_sp(:,3) data_lp_sp(:,4) ];
    lp_sp_Vxyz = [ data_lp_sp(:,7) data_lp_sp(:,8) data_lp_sp(:,9) ];
  else time_lp_sp = 0; lp_sp_xyz = [ 0 0 0 ]; lp_sp_Vxyz = [ 0 0 0 ];
  endif;
  data_sens = dlmread(fname_sens,',',1,0);
  if(data_dbg_vect_avail) 
    data_dbg_vect = dlmread(fname_debug_vect,',',1,0);
    time_dbg_vect = data_dbg_vect(:,1)/1000000; 
    dbg_vect_xyz = [ data_dbg_vect(:,3) data_dbg_vect(:,4) data_dbg_vect(:,5) ];
  else time_dbg_vect = 0; dbg_vect_xyz=[0 0 0];
  endif;
  if(data_flow_avail)
    data_flow = dlmread(fname_flow,',',1,0);
    time_flow = data_flow(:,1)/1000000; flow_int_xy = [ data_flow(:,2) data_flow(:,3) ];
  else flow_int_xy = [ 0 0 ];
  endif;
  if(data_sensor_avail)
    time_sensor = data_sens(:,1)/1000000; 
    gyro_xyz =[ data_sens(:,2) data_sens(:,3) data_sens(:,4) ]; 
    acc_xyz = [ data_sens(:,7) data_sens(:,8) data_sens(:,9) ];
  else time_sensor = 0; gyro_xyz = [ 0 0 0 ]; acc_xyz = [ 0 0 0 ];
  endif
  if(data_distance_avail) 
    data_distance = dlmread(fname_dist,',',1,0);
    time_dist = data_distance(:,1)/1000000; 
    current_distance = data_distance(:,4);
  else time_dist = 0; current_distance = 0;
  endif;
  if(data_input_rc_avail)
    data_input_rc = dlmread(fname_input_rc,',',1,0); 
    time_input_rc = data_input_rc(:,1)/1000000; 
    input_rc = [ data_input_rc(:,8) data_input_rc(:,9) data_input_rc(:,10) data_input_rc(:,11) data_input_rc(:,12) ];
  else time_input_rc = 0; input_rc = [0 0 0 0 0];
  endif;
  if(data_pwr_sys_avail)
      data_pwr_sys = dlmread(fname_power_sys,',',1,0);
      time_pwr_sys = data_pwr_sys(:,1)/1000000; 
      pwr_sys_5v = data_pwr_sys(:,2);
    else time_pwr_sys = 0; pwr_sys_5v = 0;
  endif;
  if(data_batt_sts_avail)
    data_batt = dlmread(fname_batt_sts, ',',1,0);
    time_batt = data_batt(:,1)/1000000; 
    batt_V = data_batt(:,2); 
    batt_curr = data_batt(:,4); 
    batt_disch_mah = data_batt(:,7);
  else
    time_batt = 0; batt_V = 0; batt_curr = 0; batt_disch_mah = 0;
  endif
  
  %% Plot attitude control
  plotAttitudeControl(time_att, att_rpy, time_att_sp, att_rpy_sp, time_input_rc, input_rc, folderName);
  %% Plot raw sensor data
  plotSensorData(time_sensor, gyro_xyz, acc_xyz, folderName);
  %% Plot for Z axis data
  plotAltitudeControl(time_lp, lp_xyz(:,3), lp_Vxyz(:,3), dist_z, dist_vz, time_lp_sp, lp_sp_xyz(:,3), lp_sp_Vxyz(:,3), time_dist, current_distance, time_input_rc, input_rc, folderName);
  %% Plot for x, y, z axis data
  plotPositionControl(time_lp, lp_xyz, lp_Vxyz, time_lp_sp, lp_sp_xyz, lp_sp_Vxyz, time_flow, flow_int_xy, time_input_rc, input_rc, folderName);
  %% Plot power source
  plotPower(time_pwr_sys, pwr_sys_5v, time_batt, batt_V, batt_curr, batt_disch_mah, folderName);
  
endfunction
%------------- END OF CODE --------------