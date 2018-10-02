function flagLandState(yl, flagYstep, time_land_detect, land_detect)
  % @Description: Plot flags at chagne of land state
  % @Input: yl ylim of plot
  %         plotYstep steps for placing text (for texts not to overlap)
  %         time_land_detect timestamp log of land detect
  %         land_detect  log of land detect
  % @Created: 2018/10/2
  % @Author: Kyuhyong You
  takeoff = false;
  pos_x_touched_prev = 0;
  pos_x_mayLanded_prev = 0;
  for i=2:length(time_land_detect)
    for j=1:4
      if(land_detect(i,j)!=land_detect(i-1,j))
        pos_x = time_land_detect(i);
        n=1;
        switch(j)
          case 1
            if(takeoff) msg = "Land"; takeoff = false; 
            else msg = sprintf("Take Off @%.2f",time_land_detect(i)); takeoff = true; endif; 
            n = 1; 
          case 2 
            msg = "Falling"; n=3;
          case 3 
            if( (pos_x - pos_x_touched_prev) < 1 ) msg = ""; 
            else msg = "Touched"; n=3; endif;
            pos_x_touched_prev = pos_x;
          case 4
            if( (pos_x - pos_x_mayLanded_prev) < 1 ) msg = "";
            else msg = "Landed?";  endif;
            pos_x_mayLanded_prev = pos_x; n=2;
        endswitch
        plot([pos_x; pos_x],[yl(1); yl(2)], "color", "r", "LineWidth", 1.3, "linestyle", "-.");
        text(pos_x, yl(2)-flagYstep*n, msg, 'FontSize',12);
      endif
    endfor
  endfor
endfunction