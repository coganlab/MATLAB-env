function ReachOnset = loadReachOnset(Session, Params)
%
%  ReachOnset = loadReachOnset(Session, Params)
%

global MONKEYDIR 

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
end

if nargin < 2
  Params.Event.Task = 'MemoryReachSaccade';
end

TaskString = [];
if iscell(Params.Event.Task)
    for iTask = 1:length(Params.Event.Task)
        TaskString = [TaskString '_' Params.Event.Task{iTask}];
    end
    TaskString = TaskString(2:end);
else
    TaskString = Params.Event.Task;
end

Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_ReachOnset..' ...
    TaskString '.Dir' num2str(Params.Event.Target) '.' SessNumString '.mat']
if exist(Filename,'file')
    load(Filename);
else
    disp([Filename ' does not exist']);
    ReachOnset = [];
end
