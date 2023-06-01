function flag = isReachTrial(TaskCode)
%  
%  flag = isReachTrial(TaskCode)
%

switch TaskCode
  case {0,1,2,3,4,5,6,7,8,11,12,16,17,24,26,27,28,29,30,32,33,39,40}  %  No visually-guided reach
    flag = 0;
  case {9,10,13,14,15,18,19,20,21,22,23,25,31,34,35,36,37,38,41}  %  Reach
    flag = 1;
end


% 0 - Sensors
% 1 - Touch
% 2 - Fixate
% 3 - Touch and Fixate
% 4 - Suppress Reach
% 5 - Suppress Reach and Fixate
% 6 - Suppress Saccade
% 7 - Suppress Saccade and Touch
% 8 - Suppress Reach and Saccade
% 9 - Delayed Reach
% 10- Delayed Reach and Fixate
% 11- Delayed Saccade
% 12- Delayed Saccade and Touch
% 13- Delayed Reach and Saccade
% 14- Memory Reach
% 15- Memory Reach and Fixate
% 16- Memory Saccade
% 17- Memory Saccade and Touch
% 18- Memory Reach and Saccade
% 19- Delayed Reach then Saccade
% 20- Delayed Saccade then Reach
% 21- Stimulus Onset Asynchrony
% 22- Memory Stimulus Onset Asynchrony
% 23- Race Reach
% 24- Race Saccade
% 25- Race Reach and Saccade
% 26- Eye Calibration
% 27- Color Discrimination
% 28- Color Discrimination Proximate
% 29- Delay Race Reach
% 30- Delay Race Saccade
% 31- Delay Race Reach and Saccade
% 32- Memory Race Reach
% 33- Memory Race Saccade
% 34- Memory Race Reach and Saccade
% 35- Immediate Double Step
% 36- PostSacc Double Step
% 37- PeriReach Double Step
% 38- PostReach Double Step
% 39- Saccade Double Step
% 40- Immediate Saccade Double Step
% 41- Memory PeriReach Double Step


