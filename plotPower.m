function plotPower(time_pwr_sys, pwr_sys_5v, time_batt, batt_V, batt_curr, batt_disch_mah, path)
  h_pwr = figure(10,'Position',[1300,900,600,400]);

  plot(time_pwr_sys, pwr_sys_5v,'LineWidth',1.5 );
  xlim( [ time_pwr_sys(1) time_pwr_sys(length(time_pwr_sys)) ] );
  ylim( [ 0 ceil(findMax(pwr_sys_5v, batt_V, batt_curr, batt_disch_mah/100))+3 ] );
  grid on;
  set (gca, "xminorgrid", "on");  
  set (gca, "yminorgrid", "on");  
  xlabel("Time(sec)");  
  title("Power");
  hold on;
  plot(time_batt, batt_V, 'LineWidth', 1.3);
  plot(time_batt, batt_curr, 'LineWidth',1.3);
  plot(time_batt, batt_disch_mah/100);
  legSys5v = sprintf("System 5V min:%.2f, max:%.2f",min(pwr_sys_5v), max(pwr_sys_5v));
  legBattV = sprintf("Battery V min:%.2f, max:%.2f",min(batt_V), max(batt_V));
  lgnd = legend(legSys5v, legBattV, "Currents(A)", "Discharge [mAh/100]");
  hold off;
  saveName = sprintf("%sPower.png", path)
  saveas(h_pwr,saveName);
endfunction
