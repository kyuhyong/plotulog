function plotSensorData(time, gyro_x, gyro_y, gyro_z, accel_x, accel_y, accel_z, path)
  h_sens = figure(3,'Position',[800,600,800,300]);
  subplot(211)
  plot(time,gyro_x);
  grid on;
  xlim( [ time(1) time(length(time)) ]);
  set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Gyro (rad/s)");  title("Raw Angular speed");
  hold on;
  plot(time, gyro_y);  plot(time, gyro_z);
  legend("X", "Y", "Z");
  hold off;
  subplot(212)
  plot(time, accel_x);  
  grid on;
  xlim( [ time(1) time(length(time)) ]);
  set (gca, "xminorgrid", "on"); xlabel("Time(sec)");  ylabel("Acceleration (m/s^2)");  title("Raw Acceleration");
  hold on;
  plot(time, accel_y);  plot(time, accel_z);
  legend("X", "Y", "Z");
  hold off;
  saveName = sprintf("%sSensor_Data.png", path)
  saveas(h_sens,saveName);
endfunction
