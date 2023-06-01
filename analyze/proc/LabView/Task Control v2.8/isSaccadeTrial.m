function flag = isSaccadeTrial(TaskCode)
%  
%  flag = isSaccadeTrial(TaskCode)
%

switch TaskCode
  case {0,1,2,3,4,5,6,7,8,9,10}  %  No saccade
    flag = 0;
  case {11,12,13}  %  Saccade
    flag = 1;
end
