function [TrialAccLLR, Trials, Onset] = loadTrialDecisionOnsetAccLLR(Session, InputParams)
%
%  [TrialAccLLR, Trials, Onset] = loadTrialDecisionOnsetAccLLR(Session, InputParams)
%
%  Params needs InputParams.Selection= 'Decision' (Default)
%               InputParams.Type =  'Visual' or 'Choice'
%               InputParams.Task  = {'DelReachSaccade' etc}
%               InputParams.SelectionTime = 'Optimal' (Default)
%

global MONKEYDIR 

if ~isfield(InputParams,'Selection');
    InputParams.Selection = 'Decision';
end
if ~isfield(InputParams,'SelectionTime')
    InputParams.SelectionTime = 'Optimal';
end

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

TaskString = [];
if iscell(InputParams.Task)
    for iTask = 1:length(InputParams.Task)
        TaskString = [TaskString '_' InputParams.Task{iTask}];
    end
    TaskString = TaskString(2:end);
else
    TaskString = InputParams.Task;
end

switch InputParams.Type
  case 'Visual'
    load([MONKEYDIR '/mat/' SessionType '/' SessionType '_' InputParams.Selection 'Onset.' InputParams.Type '.' ...
      TaskString '.Dir' num2str(InputParams.Event.Target) '.' SessNumString '.mat']);
%     DetectType = 'Hit';
    Onset = DecisionOnset;
  case 'Choice'
    load([MONKEYDIR '/mat/' SessionType '/' SessionType '_' InputParams.Selection 'Onset.' InputParams.Type '.' ...
      TaskString '.' SessNumString '.mat']);
%     DetectType = 'Correct';
    Onset = DecisionOnset;
    
end

switch InputParams.Type
    case 'Visual'
        Trials = [Onset.Data(1).Trials.Event];
        TrialAccLLR = zeros(length(Onset.Results),length(Trials),size(Onset.Results(1).NoHist.Event.AccLLR,2));
    case 'Choice'
        Trials = [Onset.Data(1).Trials.Event Onset.Data(1).Trials.Null];
        TrialAccLLR = zeros(length(Onset.Results),length(Trials),size(Onset.Results(1).NoHist.Null.AccLLR,2));
end
for iType = 1:length(Onset.Results)
    AccLLRNull = Onset.Results(iType).NoHist.Null.AccLLR;
    AccLLREvent = Onset.Results(iType).NoHist.Event.AccLLR;

    switch InputParams.Type
        case 'Visual'
            TrialAccLLR(iType,:,:) = AccLLREvent;
        case 'Choice'
            TrialAccLLR(iType,:,:) = [AccLLREvent ;AccLLRNull];
    end
end

%  Sort the trials to give original trial ordering
Recs = getRec(Trials);
uRecs = unique(Recs);

TrialIndices = [];
for iRec = 1:length(uRecs)
    RecIndices = find(ismember(Recs,uRecs{iRec}));
    SubTrials = [Trials(RecIndices).Trial];
    [dum,SubTrialIndices] = sort(SubTrials,'ascend');
    TrialIndices = [TrialIndices RecIndices(SubTrialIndices)];
end

Trials = Trials(TrialIndices);
TrialAccLLR = TrialAccLLR(:,TrialIndices,:);

TrialAccLLR = sq(TrialAccLLR);

