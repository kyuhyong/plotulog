function retState = getNavState(state)
  % Return description of navigation state number
  % All descriptions are from px4 code here 
  % https://github.com/PX4/Firmware/blob/d3c37e0206c4ed50e64ade05c95a580a5bb18eb7/msg/vehicle_status.msg#L23
  % Author: Kyuhyong You
  % Date: 2018/9/28
  switch(state)
    case 0
      retState = "Manual";
    case 1
      retState = "ALTCTL";
    case 2
      retState = "POSCTL";
    case 3
      retState = "AUTO";
    case 4
      retState = "LOITER";
    case 5
      retState = "RTL";
    case 6
      retState = "RECOVER";
    case 7
      retState = "RTGS";
    case 8
      retState = "LandEngFail";
    case 9
      retState = "LandGPSFail";
    case 10
      retState = "ACRO";
    case 11
      retState = "UNUSED";
    case 12
      retState = "DESCEND";
    case 13
      retState = "TERMINATE";
    case 14
      retState = "OFF BRD";
    case 15
      retState = "STAB";
    case 16
      retState = "Rattitude";
    case 17
      retState = "Auto TO";
    case 18
      retState = "Auto Land";
    case 19
      retState = "FLW TGT";
    case 20
      retState = "Prec Land";
    case 21
      retState = "Max";
    otherwise
      retState = "Not supported";
    endswitch
  endfunction
  