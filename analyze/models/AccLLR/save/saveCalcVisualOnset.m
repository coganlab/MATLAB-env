function saveCalcVisualOnset(Session, Params, OverwriteFlag,filename)
%
% saveCalcVisualOnset(Session, Params, OverwriteFlag)
%

global MONKEYDIR

if nargin < 2
  Params.Event.Target = 1;
  Params.Task = 'DelSaccadeTouch';
  Params.MaximumTimetoOnsetDetection = 200;
  Params.TrialAvgdDetect = 0;
end
if nargin < 3; OverwriteFlag = 0; end
file = 1;
if nargin < 4
    file = 0;
end
Params.Selection = '';
Params.Type = 'Visual';

MaxTime = Params.MaximumTimetoOnsetDetection;
bn = [-100,MaxTime+100];
Params.Event.Task = Params.Task;

Params.Event.Field = 'TargsOn'; Params.Event.bn = bn;
Params.Null.Task = Params.Task;
Params.Null.Target = [];
Params.Null.Field = 'TargsOn'; 
Params.Null.bn = [-500,-500+MaxTime+200];
Params.StartofAccumulationTime = -bn(1);

Params.compbound2 = 190; Params.MaxGLMOrder = 20;
Params.Hist = 0; Params.NoHist = 1; Params.VarNoHist = 0; 

if iscell(Session{1})
    SessionType = getSessionType(Session{1});
    SessionNumberString = Params.Label;
else
    SessionType = getSessionType(Session);
    SessionNumberString = saveSessionNumberStringHelper(Session);
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
    TaskString '.Dir' num2str(Params.Event.Target(1)) '.' SessionNumberString '.mat'];
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
            [Results,Data,Model] = loocalcOnsetS(Session,Params);
        case 'Field'
            [Results,Data,Model] = loocalcOnsetF(Session,Params);
        case 'SpikeField'
            [Results,Data,Model] = loocalcOnsetSF(Session,Params);
        case 'FieldField'
            [Results,Data,Model] = loocalcOnsetFF(Session,Params);
        case 'SpikeSpike'
            [Results,Data,Model] = loocalcOnsetSS(Session,Params);
    end

    Onset.Results = Results;
    Onset.Data = Data;
    Onset.Model = Model;
    Onset.Session = Session;
    Onset.Params = Params;
    save(Filename, 'Onset');
end

