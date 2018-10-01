function compareSensorLogs(arg1, arg2)
  % Compare csv converted log files in one plot
  % Input: folder names which contains csv file subject to compare
  % Example: compareCsvLog("001_log/","002_log/")
  % Created: 2018/10/1
  % Author: Kyuhyong You
  [time_sensor1 acc1_xyz gyro1_xyz] = readSensorData(arg1);
  [time_sensor2 acc2_xyz gyro2_xyz] = readSensorData(arg2);
  
  % Adjust time difference between two sensor data
  if(time_sensor1(1) > time_sensor2(1)) 
    time_gap = time_sensor1(1) - time_sensor2(1);
    for i=1: length(time_sensor1)
      time_sensor1(i) = time_sensor1(i)-time_gap;
    endfor
  else 
    time_gap = time_sensor2(1) - time_sensor1(1);
    for i=1: length(time_sensor2)
      time_sensor2(i) = time_sensor2(i)-time_gap;
    endfor
  endif
  
  h_gyro = figure(1,'Position',[50,900,800,400]);
  clf(h_gyro);
  subplot(121);
    plot(time_sensor1, gyro1_xyz(:,1));
    grid on;
    %if(length(time_sensor1) < length(time_sensor2)) xlim( [time_sensor1(1) time_sensor1(length(time_sensor1))] );
    %else xlim([time_sensor2(1) time_sensor2(length(time_sensor2))]);
    %endif
    xlim([time_sensor1(1) time_sensor1(length(time_sensor1))]);
    maxy = max( max( max(gyro1_xyz), max(gyro2_xyz) ));
    miny = min( min( min(gyro1_xyz), min(gyro2_xyz) ));
    ylim([miny maxy]);
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Angular speed (rad/s)");  title("Gyro 1");
    hold on;
    plot(time_sensor1, gyro1_xyz(:,2));  
    plot(time_sensor1, gyro1_xyz(:,3));
    legend("X", "Y", "Z");
    hold off;
  subplot(122);
    plot(time_sensor2, gyro2_xyz(:,1));
    grid on;
    xlim([time_sensor2(1) time_sensor2(length(time_sensor2))]);
    ylim([miny maxy]);
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Angular speed (rad/s)");  title("Gyro 2");
    hold on;
    plot(time_sensor2, gyro2_xyz(:,2));  
    plot(time_sensor2, gyro2_xyz(:,3));
    legend("X", "Y", "Z");
    hold off;
    
  h_acc = figure(2,'Position',[50,400,800,400]);
  clf(h_acc);
  subplot(121);
    plot(time_sensor1, acc1_xyz(:,1));
    xlim([time_sensor1(1) time_sensor1(length(time_sensor1))]);
    maxy = max( max( max(acc1_xyz), max(acc2_xyz) ));
    miny = min( min( min(acc1_xyz), min(acc2_xyz) ));
    ylim([miny maxy]);
    grid on;
    set (gca, "xminorgrid", "on");set (gca, "yminorgrid", "on");
    xlabel("Time(sec)");  ylabel("Acceleration (m/s^2)");  title("Accelerometer 1");
    hold on;
    plot(time_sensor1, acc1_xyz(:,2));  
    plot(time_sensor1, acc1_xyz(:,3));
    legend("X", "Y", "Z");
    hold off;  
  subplot(122);
    plot(time_sensor2, acc2_xyz(:,1));
    xlim([time_sensor2(1) time_sensor2(length(time_sensor2))]);
    ylim([miny maxy]);
    set (gca, "xminorgrid", "on");set (gca, "yminorgrid", "on");
    xlabel("Time(sec)");  ylabel("Acceleration (m/s^2)");  title("Accelerometer 2");
    hold on;  
    plot(time_sensor2, acc2_xyz(:,2));  
    plot(time_sensor2, acc2_xyz(:,3));
    legend("X", "Y", "Z");
    hold off;
endfunction