function DecisionOnset = loadDecisionChoiceOnset(Session, Params)
%
%  DecisionOnset = loadDecisionChoiceOnset(Session, Params)
%

global MONKEYDIR 

if iscell(Session{1})
    SessionType = getSessionType(Session{1});
    SessionLabelString = Params.Label;
else
    SessionType = getSessionType(Session);
    switch SessionType
        case 'Spike'
            SessionLabelString = num2str(Session{6}(1));
        case 'Field'
            SessionLabelString = num2str(Session{6}(1));
        case 'SpikeField'
            SessionLabelString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
        case 'FieldField'
            SessionLabelString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
        case 'SpikeSpike'
            SessionLabelString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
        case 'Multiunit'
            SessionLabelString = num2str(Session{6}(1));
    end
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


if iscell(Session{1})
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_DecisionOnset.Choice.' ...
        TaskString '.' SessionLabelString '.mat'];
else
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_DecisionOnset.Choice.' ...
        TaskString '.' SessionLabelString '.mat'];
end
if exist(Filename ,'file');
    disp(['Loading ' Filename]);
    load(Filename);
else
    disp([Filename ' does not exist']);
    DecisionOnset = [];
end


