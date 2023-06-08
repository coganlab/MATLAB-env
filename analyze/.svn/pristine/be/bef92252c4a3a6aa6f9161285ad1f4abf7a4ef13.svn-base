function saveCalcDecisionGoOnset(Session, Params, OverwriteFlag)
%
% saveCalcDecisionGoOnset(Session, Params, OverwriteFlag)
%
%  Params.Event.Task
%  Params.Null.Task
%  Params.Event.Target
%  Params.MaximumTimetoOnsetDetection
%  Params.TrialAvgdDetect
%
%
global MONKEYDIR

if nargin < 2
    Params.Event.Target = 1;  Params.Null.Target = 1;
    Params.Task = 'DelSaccadeTouch';
    Params.MaximumTimetoOnsetDetection = 1000;
    Params.TrialAvgdDetect = 1;
end
if nargin < 3;    OverwriteFlag = 0; end


Params.Selection = 'Decision';
Params.Type = 'MovementStart';

Params.Null.Target = Params.Event.Target;

bn = [-200,Params.MaximumTimetoOnsetDetection+100];
Params.Event.Field = 'MovementStart'; Params.Event.bn = bn;
Params.Null.Field = 'MovementStart'; Params.Null.bn = bn;
Params.StartofAccumulationTime = -bn(1);

Params.compbound2 = 190; Params.MaxGLMOrder = 20;
Params.Hist = 0; Params.NoHist = 1; Params.VarNoHist = 0;

SessionType = getSessionType(Session);
SessionNumberString = saveSessionNumberStringHelper(Session);

TaskString = [Params.Event.Task{1} '_' Params.Null.Task{1}];

Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_' Params.Selection 'Onset.' Params.Type '.' ...
    TaskString '.Dir' num2str(Params.Event.Target(1)) '.' SessionNumberString '.mat'];

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
    end

    DecisionOnset.Results = Results;
    DecisionOnset.Data = Data;
    DecisionOnset.Model = Model;
    DecisionOnset.Session = Session;
    DecisionOnset.Params = Params;
    disp(['Saving ' Filename]);
    save(Filename, 'DecisionOnset');
end
