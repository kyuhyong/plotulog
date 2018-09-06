function retval = checkFile(arg1)
  retval = false;
  if(exist(arg1,"file") != 2)
    str = sprintf("%s File not exists!\n", arg1);
    disp(str)
    return
  else 
    retval = true;
  endif
endfunction
