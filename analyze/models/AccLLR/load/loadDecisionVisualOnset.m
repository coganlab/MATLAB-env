function DecisionOnset = loadDecisionVisualOnset(Session, Params,filename)
%
%  DecisionOnset = loadDecisionVisualOnset(Session, Params)
%

global MONKEYDIR 
file = 1;
if nargin < 3
    file = 0;
end

if iscell(Session{1})
    SessionType = getSessionType(Session{1});
    SessionLabelString = Params.Label;
else
    SessionType = getSessionType(Session);
    switch SessionType
        case 'Spike'
            SessNumString = num2str(Session{6}(1));
        case 'Field'
            SessNumString = num2str(Session{6}(1));
        case 'SpikeField'
            SessNumString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
        case 'FieldField'
            SessNumString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
        case 'SpikeSpike'
            SessNumString = [num2str(Session{6}(1)) '_' num2str(Session{6}(2))];
        case 'Multiunit'
            SessNumString = num2str(Session{6}(1));
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
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_DecisionOnset.Visual.' ...
        TaskString '.' SessionLabelString '.mat'];
else
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_DecisionOnset.Visual.' ...
        TaskString '.Dir' num2str(Params.Event.Target) '.' SessNumString '.mat']
end
if(file)
    Filename = filename;
end
if exist(Filename,'file')
    disp(['Loading ' Filename]);
    load(Filename);
else
    disp([Filename ' does not exist']);
    DecisionOnset = [];
end
