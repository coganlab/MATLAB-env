function Trials = trialTask(Trials,Task)
%   trialTask returns trials for a given task
%
%   Trials = trialTask(Trials,task)
%
%  Inputs:  TRIALS  =   Trials data structure
%           TASK    =   String.  Task to select.
%                           eg 'Free3T'
%                           Defaults to Free3T
%
%  Outputs: TRIALS  =   Trials data structure
%

global ind

if nargin < 2
    Task = 'DelReachSaccade';
end

if length(Trials)
    TaskCode = getTaskCode(Trials);
      JoyCode = [Trials.Joystick];
    
    switch Task
        case 'ColorDiscrimination'
            ind = find(TaskCode==27);
        case 'EyeCalibration'
            ind = find(TaskCode==26);
        case 'RaceReachSaccade'
            ind = find(TaskCode==25);
        case 'RaceSaccade'
            ind = find(TaskCode==24);
        case 'RaceReach'
            ind = find(TaskCode==23);
        case 'MemorySOA'
            ind = find(TaskCode==22);
        case 'SOA'
            ind = find(TaskCode==21);
        case 'DelSaccadethenReach'
            ind = find(TaskCode==20 & JoyCode==0);
        case 'DelSaccadethenJoy'
            ind = find(TaskCode==20 & JoyCode==1);
        case 'DelReachthenSaccade'
            ind = find(TaskCode==19 & JoyCode==0);  
        case 'DelJoythenSaccade'
            ind = find(TaskCode==19 & JoyCode==1);
        case 'MemoryReachSaccade'
            ind = find(TaskCode==18 & JoyCode==0);
        case 'MemoryJoySaccade'
            ind = find(TaskCode==18 & JoyCode==1);
        case 'MemorySaccadeTouch'
            ind = find(TaskCode==17);
        case 'MemorySaccade'
            ind = find(TaskCode==16);
        case 'MemoryReachFix'
            ind = find(TaskCode==15 & JoyCode==0);
        case 'MemoryJoyFix'
            ind = find(TaskCode==15 & JoyCode==1);
        case 'MemoryReach'
            ind = find(TaskCode==14 & JoyCode==0);
         case 'MemoryJoy'
            ind = find(TaskCode==14 & JoyCode==1);
        case 'DelReachSaccade'
            ind = find(TaskCode==13 & JoyCode==0);
        case 'DelJoySaccade'
            ind = find(TaskCode==13 & JoyCode==1);
        case 'DelSaccadeTouch'
            ind = find(TaskCode==12);
        case 'DelSaccade'
            ind = find(TaskCode==11);
        case 'DelReachFix'
            ind = find(TaskCode==10 & JoyCode==0);
        case 'DelReachFix'
            ind = find(TaskCode==10 & JoyCode==1);
        case 'DelReach'
            ind = find(TaskCode==9 & JoyCode==0);
        case 'DelJoy'
            ind = find(TaskCode==9 & JoyCode==1);
        case 'SuppReachSaccade'
            ind = find(TaskCode==8);
        case 'SuppSaccadeTouch'
            ind = find(TaskCode==7);
        case 'SuppSaccade'
            ind = find(TaskCode==6);
        case 'SuppReachFix'
            ind = find(TaskCode==5);
        case 'SuppReach'
            ind = find(TaskCode==4);
        case 'TouchFix'
            ind = find(TaskCode==3);
        case 'Fixate'
            ind = find(TaskCode==2);
        case 'Touch'
            ind = find(TaskCode==1);
        case 'Sensors'
            ind = find(TaskCode==0);
        case 'Stim'
            ind = find(TaskCode==100);
    end
    if length(ind)
        Trials = Trials(ind);
    else
        %disp('No Trials');
        Trials = [];
    end
end
if length(Trials)
 disp([num2str(length(Trials)) ' ' Task ' trials'])
end
