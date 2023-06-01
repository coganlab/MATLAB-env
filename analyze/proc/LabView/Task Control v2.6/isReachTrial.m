function flag = isReachTrial(TaskCode)
%  
%  flag = isReachTrial(TaskCode)
%

switch TaskCode
  case {0,1,2,3,4,5,6,7,8,11,12}  %  No reach
    flag = 0;
  case {9,10,13}  %  Reach
    flag = 1;
end
