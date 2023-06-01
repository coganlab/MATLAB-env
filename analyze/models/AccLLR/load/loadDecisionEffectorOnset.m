function DecisionOnset = loadDecisionEffectorOnset(Session, Params)
%
%  DecisionOnset = loadDecisionEffectorOnset(Session, Params)
%
%   Params.Type
%   Params.Selection
%   Params.Event.Task
%   Params.Null.Task
%   Params.Event.Target

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


% EventTaskString = [];
% if iscell(Params.Event.Task)
%     for iTask = 1:length(Params.Event.Task)
%         EventTaskString = [EventTaskString '_' Params.Event.Task{iTask}];
%     end
%     EventTaskString = EventTaskString(2:end);
% else
%     EventTaskString = Params.Event.Task;
% end
% 
% NullTaskString = [];
% if iscell(Params.Null.Task)
%     for iTask = 1:length(Params.Null.Task)
%         NullTaskString = [NullTaskString '_' Params.Null.Task{iTask}];
%     end
%     NullTaskString = NullTaskString(2:end);
% else
%     NullTaskString = Params.Null.Task;
% end


TaskString =  [Params.Event.Task{1} '_' Params.Null.Task{1}];

Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_Decision' ...
    'Onset.Effector.' TaskString '.Dir' num2str(Params.Event.Target) ...
    '.' SessNumString '.mat']

if exist(Filename,'file')
    load(Filename);
else
    disp([Filename ' does not exist']);
    DecisionOnset = [];
end
