function flag = isReachTrial(TaskCode)
%  
%  flag = isReachTrial(TaskCode)
%

TaskCode
switch TaskCode
  case {0,1,2,3,4,5,6,7,8,11,12,16,17,23,24,25}  %  No visually-guided reach
    flag = 0;
  case {9,10,13,14,15,18,19,20,21,22}  %  Reach
    flag = 1;
end
