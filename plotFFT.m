function plotFFT(time, x, argt, ylbl, rng, path)
% Inputs:
%    time - time stamp of data x
%    x - Sensor data
%    argt - Title of plot
%    ylbl - Ylabel of plot
%    rng - range of data want to look at
%    path - path to save files
% Example: 
%    plotUlogs("log001.ulg","Test1")
%    plotUlogs("001_Test1\")
%
% Author: Kyuhyong You
% Website: https://github.com/kyuhyong/plotulog
% Jan 2019/1/8; 
% Revision: -
  %------------- BEGIN CODE --------------
  % Strip data when none zero range is entered
  if(rng != 0) 
    startIdx = 0;
    tailIdx = 0;
    idx = 1;
    while(tailIdx==0)
      if(idx>length(time)) disp("Err: Out of range"); return; endif
      if(time(idx) < rng(1)) startIdx++; endif
      if(time(idx) > rng(2)) tailIdx = idx; endif
      idx++;
    endwhile
    time = time(startIdx:tailIdx);
    x = x(startIdx:tailIdx);
  endif

  saveName = sprintf("%sFFT_of_%s", path, argt)
  
  h_fft=figure;
  clf(h_fft);
  subplot(2,1,1);  
  plot(time, x,"LineWidth", 1.0);
  grid on;
  set (gca, "xminorgrid", "on");  set (gca, "yminorgrid", "on");
  xlabel("Time (sec)");
  ylabel(ylbl);
  title(argt);
  
  Ts = mean(diff(time));  % Sampling period
  Fs = 1/Ts;              % Sampling Frequency
  Fn = Fs/2;              % Niquist Frequency
  N = length(x);          % Length of signal
  
  % Apply fourrie transfer
  Y = fft(x);
  FT_Signal = fft(x) / N;     % Normalized Fourier Transform
  Fv = linspace(0, 1, fix(N/2)+1)*Fn; % Frequency vector
  Iv = 1:length(Fv);                  % Index vector
  strmatrix = [sprintf("Fs = %.2f Hz", Fs); sprintf("Fn = %.2f Hz",Fn); sprintf("N = %d",N)];
  subplot(2,1,2);
  plot(Fv, abs(FT_Signal(Iv))*2, 'r', 'LineWidth', 1.0);
  ylim( [ 0.0 0.5 ]);
  %plot(f, Pxx, 'r', 'LineWidth', 1.5);
  grid on;
  xlabel("Frequency (Hz)"); ylabel("|P1(f)|");
  title(sprintf("Single-Sided Amplitude Spectrum of %s", argt));
  annotation("textbox",[.7 .3 .4 .2], "string", strmatrix);
  print(h_fft, saveName, "-dpdf","-color","-S400,800");
  print(h_fft, saveName, "-dpng","-color", "-r200");
endfunction
