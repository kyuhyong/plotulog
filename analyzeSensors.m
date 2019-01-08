function analyzeSensors(varargin)
% Inputs:
%    arg1 - Folder name of already created csv files location
%    arg2 - Range of data to analyze in seconds. Null for anlyze full
%
% Example: 
%    analyzeSensors("001_Test1\",[10.0 20.0]) for analyze data from 10.0 sec to 20.0 esc
%    analyzeSensors("001_Test1\")
%
% Other m-files required: checkFile.m plotFFT.m
% Author: Kyuhyong You
% Website: https://github.com/kyuhyong/plotulog
% Jan 2018; 
% Revision: -
  %------------- BEGIN CODE --------------
  input_folderName = false;
  argnum = length(varargin);
  arg1 = varargin{1};
  % Check if first input argument is folder name and exists
  if(exist(arg1,"dir") == 7)
    folderName = arg1;
  else
    disp("Not a folder or does not exists!")
    return;
  endif 
  % Split folder name with leading number for searching file name
  if(strfind(folderName,'_')>0)
    fnum = strsplit(folderName,'_'){1};
  else
    fnum = strsplit(folderName,'/'){1};
  endif
  fnames = dir(folderName);
  fname_sens = sprintf("%slog%s_sensor_combined_0.csv",folderName, fnum)
  
  % Check file
  if(!checkFile(fname_sens)) 
    disp("Sensor data file "),disp(fname_sens),disp(" does not exist!"); return; 
  endif;
  
  % Read data in the file
  data_sens = dlmread(fname_sens,',',1,0);
  time_sensor = data_sens(:,1)/1000000; 
  gyro_xyz =[ data_sens(:,2) data_sens(:,3) data_sens(:,4) ];
  acc_xyz = [ data_sens(:,7) data_sens(:,8) data_sens(:,9) ];
  
  % Check viewing range if entered
  range = 0;
  if(argnum > 1) 
    range = varargin{2};
    [nr, nc] = size(range);
    if(nr!=1 || nc!=2) disp("Err: Size mismatch, Range is matrix must be [start finish]"); return;
    elseif(range(2) < range(1)) disp("Err: Range mismatch"),disp(range); return;
    elseif(range(1) < time_sensor(1) || range(1) > time_sensor(length(time_sensor))) 
      disp("Err: Range(1) cannot be smaller than"), disp(time_sensor(1)); return;
    elseif(range(2) < time_sensor(1) || range(2) > time_sensor(length(time_sensor))) 
      disp("Err: Range(2) cannot be bigger than"), disp(time_sensor(length(time_sensor))); return;
    endif;
    printf("Range is set from %f to %f\n", range(1), range(2));
  endif;
  
  plotFFT(time_sensor, acc_xyz(:,1),"Acc X", "Acc (m/s^2)", range, folderName);
  plotFFT(time_sensor, acc_xyz(:,2),"Acc Y", "Acc (m/s^2)", range, folderName);
  plotFFT(time_sensor, acc_xyz(:,3),"Acc Z", "Acc (m/s^2)", range, folderName);
  
  plotFFT(time_sensor, gyro_xyz(:,1),"Gyro X", "Gyro (rad/s^2)", range, folderName);
  plotFFT(time_sensor, gyro_xyz(:,2),"Gyro Y", "Gyro (rad/s^2)", range, folderName);
  plotFFT(time_sensor, gyro_xyz(:,3),"Gyro Z", "Gyro (rad/s^2)", range, folderName);
  
endfunction
