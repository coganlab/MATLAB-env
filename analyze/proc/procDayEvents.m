function procDayEvents(day,rec)
%
% procDayEvents(day,rec)
%

global MONKEYDIR
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

% where's analyze?
analyzepath=which('procDayEvents');
analyzepath=analyzepath(1:end-16);

labviewflag = isfile([MONKEYDIR '/' day '/' recs{num(1)} '/rec' recs{num(1)} '.ev.txt']);
psychtoolboxflag = isfile([MONKEYDIR '/' day '/' recs{num(1)} '/rec' recs{num(1)} '.nev']);

for iRec = num(1):num(2)
    if labviewflag
        if(~exist([MONKEYDIR '/' day '/' recs{iRec} '/rec' recs{iRec} '.display.dat'],'file'))
            p = [MONKEYDIR '/' day '/DisplaySensorNotPresent.mat'];
            save(p,'iRec');
        end
        load([MONKEYDIR '/' day '/' recs{iRec} '/rec' recs{iRec} '.Rec.mat']);
        %load([MONKEYDIR '/' day '/' recs{iRec} '/rec' recs{iRec} '.experiment.mat']);
        warning off;
        rmpath(genpath([analyzepath '/LabView/']));
        addpath([analyzepath '/LabView/' Rec.Task]);
        warning on;
        which procEvents
        procEvents(day,iRec);
        warning off;
        rmpath([analyzepath '/LabView/' Rec.Task]);
        warning on;
    elseif psychtoolboxflag
        load([MONKEYDIR '/' day '/' recs{iRec} '/rec' recs{iRec} '.Rec.mat']);
        %load([MONKEYDIR '/' day '/' recs{iRec} '/rec' recs{iRec} '.experiment.mat']);
        warning off;
        rmpath(genpath([analyzepath '/Psychtoolbox/']));
        addpath([analyzepath '/Psychtoolbox/' Rec.Task]);
        warning on;
        which procEvents
        procEvents(day,iRec);
        warning off;
        rmpath([analyzepath '/Psychtoolbox/' Rec.Task]);
        warning on;
    end
end

saveTrials(day);