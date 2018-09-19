function plotSensorData(time, gyro_xyz, accel_xyz, path)
  h_sens = figure(3,'Position',[50,700,600,400]);
  subplot(211)
    plot(time, gyro_xyz(:,1));
    grid on;
    xlim( [ time(1) time(length(time)) ]);
    set (gca, "xminorgrid", "on");  xlabel("Time(sec)");  ylabel("Gyro (rad/s)");  title("Raw Angular speed");
    hold on;
    plot(time, gyro_xyz(:,2));  
    plot(time, gyro_xyz(:,3));
    legend("X", "Y", "Z");
    hold off;
  subplot(212)
    plot(time, accel_xyz(:,1));  
    grid on;
    xlim( [ time(1) time(length(time)) ]);
    set (gca, "xminorgrid", "on"); xlabel("Time(sec)");  ylabel("Acceleration (m/s^2)");  title("Raw Acceleration");
    hold on;
    plot(time, accel_xyz(:,2));  
    plot(time, accel_xyz(:,3));
    legend("X", "Y", "Z");
    hold off;
  saveName = sprintf("%sSensor_Data.png", path)
  saveas(h_sens,saveName);
endfunction
