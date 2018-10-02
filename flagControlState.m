function flagControlState(plotYmin, plotYmax, plotYstep, time_v_status, v_status)
  % @Description: Plot flags at chagne of control state
  % @Input: plotYmin minimum plot y axis
  %         plotYmax maximum plot y axis
  %         plotYstep steps for placing text (for texts not to overlap)
  %         time_v_status timestamp log of vehicle state
  %         v_status  log of vehicle state change
  % @Created: 2018/10/2
  % @Author: Kyuhyong You
  plot([time_v_status(1); time_v_status(1)],[plotYmin; plotYmax], "color", "b", "LineWidth", 1.3, "linestyle", "--");
  text(time_v_status(1), plotYmin+plotYstep, getNavState(v_status(1,1)), 'FontSize',12);
  pos_x_prev = 0;
  for i=2:length(time_v_status)
    if( v_status(i,1) != v_status(i-1,1) )
      pos_x = time_v_status(i);
      if( (pos_x - pos_x_prev) < 1) n=2; else n=1; endif;
      msg = getNavState(v_status(i,1));
      plot([pos_x; pos_x],[plotYmin; plotYmax], "color", "b", "LineWidth", 1.3, "linestyle", "--");
      text(pos_x, plotYmin+plotYstep*n, msg, 'FontSize',12);
      pos_x_prev = pos_x;
    endif
  endfor
endfunction
  