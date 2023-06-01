function flag = isSaccadeTrial(TaskCode)
%  
%  flag = isSaccadeTrial(TaskCode)
%

switch TaskCode
  case {0,1,2,3,4,5,6,7,8,9,10,14,15,23,26}  %  No saccade
    flag = 0;
  case {11,12,13,16,17,18,19,20,21,22,24,25}  %  Saccade
    flag = 1;
end
