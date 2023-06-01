function AccLLROnset = loadAccLLROnset(Session, Params)
%
%  AccLLROnset = loadAccLLROnset(Session, Params)
%

global MONKEYDIR 

if iscell(Session{1})
    SessionType = getSessionType(Session{1});
    SessionLabelString = Params.Label;
else
    SessionType = getSessionType(Session);
    SessionLabelString = saveSessionNumberStringHelper(Session);
end

TaskString = [];
if iscell(Params.Task)
    for iTask = 1:length(Params.Task)
        TaskString = [TaskString '_' Params.Task{iTask}];
    end
    TaskString = TaskString(2:end);
else
    TaskString = Params.Task;
end

Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_' Params.Selection 'Onset.' Params.Type '.' ...
    TaskString '.' SessionLabelString '.mat'];

if exist(Filename ,'file');
    disp(['Loading ' Filename]);
    load(Filename);
else
    disp([Filename ' does not exist']);
    AccLLROnset = [];
end


