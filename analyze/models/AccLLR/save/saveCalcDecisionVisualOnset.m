function saveCalcDecisionVisualOnset(Session, Params, OverwriteFlag,filename)
%
% saveCalcDecisionVisualOnset(Session, Params, OverwriteFlag)
%
%
%  Inputs:	SESSION = Cell array.  Session information.  Can include multiple sessions
%		PARAMS	= Data structure.  
%			Defaults:
%  				Params.Event.Target = 1;
%  				Params.Task = 'DelSaccadeTouch';
%  				Params.MaximumTimetoOnsetDetection = 150;
%  				Params.TrialAvgdDetect = 0;
%  				Params.Null.Static = 1;
%               Params.Monkey = cell array of monkey name strings one for each
%               sessions (if multiple sessions are inputted)
%  
%	

global MONKEYDIR

if nargin < 2
  Params.Event.Target = 1;
  Params.Task = 'DelSaccadeTouch';
  Params.MaximumTimetoOnsetDetection = 150;
  Params.TrialAvgdDetect = 0;
  Params.Null.Static = 1;
  Params.Label = 'PooledPopulation';
end
if nargin < 3; OverwriteFlag = 0; end

file = 1;
if nargin < 4
    file = 0;
end
Params.Selection = 'Decision';
Params.Type = 'Visual';

NullTarget = mod(Params.Event.Target+4,8);
NullTarget(NullTarget == 0) = 8;
Params.Null.Target = [Params.Event.Target NullTarget];
Params.Event.Target = [Params.Event.Target NullTarget];

MaxTime = Params.MaximumTimetoOnsetDetection;
bn = [-50,MaxTime+50];
Params.Event.Task = Params.Task;

Params.Event.Field = 'TargsOn'; Params.Event.bn = bn;
Params.Null.Task = Params.Task;
Params.Null.Target = [];
Params.Null.Field = 'TargsOn'; 

if isfield(Params.Null,'Static')
else
    Params.Null.Static = 1;
end
if isfield(Params,'Label')
else
    Params.Label = '';
end
Params.Null.bn = [0-MaxTime-100,0];

Params.StartofAccumulationTime = -bn(1);


Params.compbound2 = 190; Params.MaxGLMOrder = 20;
Params.Hist = 0; Params.NoHist = 1; Params.VarNoHist = 0; 

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
if iscell(Session{1})
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_' Params.Selection 'Onset.' Params.Type '.' ...
        TaskString '.' SessionLabelString '.mat'];
else
    Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_' Params.Selection 'Onset.' Params.Type '.' ...
        TaskString '.Dir' num2str(Params.Event.Target(1)) '.' SessionLabelString Params.Label '.mat'];
end
if(file)
    Filename = filename;
end
FileFlag = exist(Filename, 'file');

if FileFlag && ~OverwriteFlag
    disp([Filename ' already saved.']);
    disp('Will not save. Overwrite flag is not set');
else
    switch SessionType
        case 'Spike'
            [Results,Data,Model] = loocalcDecisionOnsetS(Session,Params);
        case 'Field'
            [Results,Data,Model] = loocalcDecisionOnsetF(Session,Params);
        case 'SpikeField'
            [Results,Data,Model] = loocalcDecisionOnsetSF(Session,Params);
        case 'FieldField'
            [Results,Data,Model] = loocalcDecisionOnsetFF(Session,Params);
        case 'SpikeSpike'
            [Results,Data,Model] = loocalcDecisionOnsetSS(Session,Params);
        case 'Multiunit'
            [Results,Data,Model] = loocalcDecisionOnsetM(Session,Params);
    end

    DecisionOnset.Results = Results;
    DecisionOnset.Data = Data;
    DecisionOnset.Model = Model;
    DecisionOnset.Session = Session;
    DecisionOnset.Params = Params;
    save(Filename, 'DecisionOnset');
end

