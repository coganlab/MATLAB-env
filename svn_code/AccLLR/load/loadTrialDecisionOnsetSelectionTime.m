function [TrialsST, Trials] = loadTrialDecisionOnsetSelectionTime(Session, InputParams)
%
%  [TrialsST, Trials] = loadTrialDecisionOnsetSelectionTime(Session, InputParams)
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
        disp('Loading Visual');
        Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_' InputParams.Selection 'Onset.' InputParams.Type '.' ...
            TaskString '.Dir' num2str(InputParams.Event.Target(1)) '.' SessNumString '.mat'];
        load(Filename);
        DetectType = 'Hit';
        Onset = DecisionOnset;
    case 'Choice'
        disp('Loading Choice');
        Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_' InputParams.Selection 'Onset.' InputParams.Type '.' ...
            TaskString '.' SessNumString '.mat'];
        load(Filename);
        DetectType = 'Correct';
        Onset = DecisionOnset;
end

for iType = 1:length(Onset.Results)
    disp(['Processing ' Onset.Results(iType).Type]);
    AccLLRNull = Onset.Results(iType).NoHist.Null.AccLLR;
    AccLLREvent = Onset.Results(iType).NoHist.Event.AccLLR;

    switch InputParams.SelectionTime
        case 'Optimal'
            [p, ST, Levels] = ...
                performance_levels(AccLLREvent, AccLLRNull, DetectType);
            switch DetectType
                case 'Hit'
                    pHit = p(:,1,1);
                    pFalseAlarm = p(:,2,1);
                    opt_p = max(pHit(pFalseAlarm<0.5));
                    ind = find(pHit==opt_p,1,'first');
                    Level = Levels(ind);
                    [dum, STEvent] = DetectAccLLR(AccLLREvent, Level, -Level);
                    STNull = [];
                    TrialsEvent = Onset.Data(1).Trials.Event;
                    TrialsNull = [];
                case 'Correct'
                    pCorrect = (p(:,1,1)+p(:,2,2))./2;
                    pIncorrect = (p(:,2,1)+p(:,1,2))./2;
                    opt_p = max(pCorrect(pIncorrect<0.5));
                    ind = find(pCorrect==opt_p,1,'first');
                    Level = Levels(ind);
                    [dum, STEvent] = DetectAccLLR(AccLLREvent, Level, -Level);
                    [dum, STNull] = DetectAccLLR(-AccLLRNull, Level, -Level);
                    TrialsEvent = Onset.Data(1).Trials.Event;
                    TrialsNull = Onset.Data(1).Trials.Null;
            end
        case 'Controlled'
            error('Controlled not supported')
    end
    TrialsST(iType,:) = [STEvent STNull];
end
Trials = [TrialsEvent TrialsNull];

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
TrialsST = TrialsST(:,TrialIndices);
