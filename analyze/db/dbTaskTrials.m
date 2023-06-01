function Trials = dbTaskTrials(day,recs,Task,MonkeyDir)
%   dbTaskTrials returns trials for a given task
%
%   Trials = dbTaskTrials(day,recs,task)
%
%  Inputs:  DAY     =   String.  Recording day to load.
%                           eg '040415'
%           RECS    =   String/Cell array.  Recordings to load
%                           eg '001' or {'001','002'}
%                           Defaults to all recordings for day.
%           TASK    =   String.  Task to load.
%                           eg 'DelReachSaccade'
%                           Defaults to DelReachSaccade
%
%  Outputs: TRIALS  =   Trials data structure
%

global MONKEYDIR

disp('Inside dbtaskTrials')
if nargin < 2 || isempty(recs)
    recs = dayrecs(day);
end

if nargin < 3 || isempty(Task)
    Task = 'DelReachSaccade';
end

if nargin < 4 || isempty(MonkeyDir)
    MonkeyDir = MONKEYDIR;
end

Trials = dbSelectTrials(day,recs,MonkeyDir);

if isempty(Trials)
    disp('No Trials');
    return
end

Trials = TaskTrials(Trials,Task);

disp([num2str(length(Trials)) ' ' Task ' trials'])
