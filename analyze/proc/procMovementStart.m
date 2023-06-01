function procMovementStart(day,rec)
%  procMovement adds an extra field to the Events structure
%
%  Inputs:  DAY        =   String. Day to detect saccades for
%           REC        =   String. Recording to detect saccades for

global MONKEYDIR 
ReachCode = 10;
SaccadeCode = 12;
ReachSaccadeCode = 13;

olddir = pwd;

recs = dayrecs(day);
nRecs = length(recs);

if nargin < 2
    num = [1,nRecs];
elseif ischar(rec)
    num = [find(strcmp(recs,rec)),find(strcmp(recs,rec))];
elseif length(rec)==1
    num = [rec,rec];
elseif length(rec)==2
    num = rec;
end

for iNum = num(1):num(2)
    load([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat']);
    try Events = rmField(Events,'MovementStart');
    catch
    end
    for iTr = 1:length(Events.Trial)
        task_code = Events.TaskCode(iTr);
        if(task_code == ReachCode) % Reach Trial
            Events.MovementStart(iTr,1) = Events.ReachStart(iTr);
        elseif(task_code == SaccadeCode) % Saccade Trial
            Events.MovementStart(iTr,1) = Events.SaccStart(iTr);
        elseif(task_code == ReachSaccadeCode) % For a reach and saccade task the time of the saccade is used.
            Events.MovementStart(iTr,1) = Events.SaccStart(iTr);
        else
            Events.MovementStart(iTr,1) = nan; 
        end
    end
    save([MONKEYDIR '/' day '/' recs{iNum} '/rec' recs{iNum} '.Events.mat'],'Events');
end

saveTrials(day);

cd(olddir);

