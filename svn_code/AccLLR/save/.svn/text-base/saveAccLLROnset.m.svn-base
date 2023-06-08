function saveAccLLROnset(Session, Params, OverwriteFlag)
%
% saveAccLLROnset(Session, Params, OverwriteFlag)
%
%  Inputs:	SESSION = Cell array.  Session information.  Can include multiple sessions
%		PARAMS	= Data structure.  
%			Defaults:
%  				Params.Event.Target = 1;
%  				Params.Task = 'DelSaccadeTouch';
%  				Params.MaximumTimetoOnsetDetection = 150;
%  				Params.TrialAvgdDetect = 0;
%  				Params.Null.Static = 1;
%               Params.Subject = cell array of subject name strings one for each
%               sessions (if multiple sessions are inputted)
%
%		Params.Selection = String.  'Update','Decision','Simple'
%		Params.Type = String. 	'Visual','Choice','Effector'
%  

global MONKEYDIR

TaskString = [];
if iscell(Params.Task)
    for iTask = 1:length(Params.Task)
        TaskString = [TaskString '_' Params.Task{iTask}];
    end
    TaskString = TaskString(2:end);
else
    TaskString = Params.Task;
end


if isfield(Params.Null,'Static')
else
    Params.Null.Static = 0;
end

if iscell(Session{1})
    SessionType = getSessionType(Session{1});
    SessionLabelString = Params.Label;
else
    SessionType = getSessionType(Session);
    SessionLabelString = saveSessionNumberStringHelper(Session);
end

Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_' Params.Selection 'Onset.' Params.Type '.' ...
    TaskString '.' SessionLabelString '.mat'];
FileFlag = exist(Filename, 'file');

if FileFlag && ~OverwriteFlag
    disp([Filename ' already saved.']);
    disp('Will not save. Overwrite flag is not set');
else
    switch SessionType
        case 'Spike'
            [Results,Data,Model] = calcAccLLROnsetS(Session,Params);
        case 'Field'
            [Results,Data,Model] = calcAccLLROnsetF(Session,Params);
        case 'SpikeField'
            [Results,Data,Model] = calcAccLLROnsetSF(Session,Params);
        case 'FieldField'
            [Results,Data,Model] = calcAccLLROnsetFF(Session,Params);
        case 'SpikeSpike'
            [Results,Data,Model] = calcAccLLROnsetSS(Session,Params);
        case 'Multiunit'
            [Results,Data,Model] = calcAccLLROnsetM(Session,Params);
    end

    AccLLROnset.Results = Results;
    AccLLROnset.Data = Data;
    AccLLROnset.Model = Model;
    AccLLROnset.Session = Session;
    AccLLROnset.Params = Params;
    save(Filename, 'AccLLROnset');
end
