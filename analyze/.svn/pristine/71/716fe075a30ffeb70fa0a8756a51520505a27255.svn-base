function postProcDay(day,startOn,jnt_file)
%
%  Generates a bunch of plots to allow a summary of experiments.
%
%  POSTPROCDAY(DAY,STARTON)
%
%  Inputs:  DAY    = String '030603'

global MONKEYDIR

if nargin < 2 || startOn > 14 || startOn < 1
    startOn = 1;
end
if nargin < 3 
    jnt_file = '';;
end



run([MONKEYDIR '/' day '/m/post_processing/post_processing_defn_file.m'])
stuffToDo = post_proc;
joint_proc_ftns = {'PostPlotJointAngles','PostPlotJointDecoding','PostPlotJointDecodingHandArm'};
disp('The following processing steps will be run:')
disp(char(stuffToDo));
jnt_file = 'Calvin_121007';
for i=startOn:length(stuffToDo)
    disp(['Now doing: ' stuffToDo{i}]);
    if(strmatch(stuffToDo{i},joint_proc_ftns))
        feval(stuffToDo{i},day,jnt_file);
    else
        feval(stuffToDo{i},day);
    end
    close all
end