function saveCalcReachOnset(Session, Params, OverwriteFlag)
%
% saveCalcReachOnset(Session, Params, OverwriteFlag)
%
%
%  SESSION 	 = Cell array.  Session information
%  PARAMS  	 = Data structure.  Analysis parameter information
%		Params.Event.Target = Scalar.  Direction for the movement.
%		Params.Null.Target  = Scalar.  Direction for the movement
%			Defaults to Params.Event.Target
%		Params.Event.Task   = String.  Task for event condition.
%			Defaults to 'MemoryReachSaccade'
%               Params.Null.Task   = String.  Task for event condition.
%                       Defaults to 'MemorySaccadeTouch'
%               Params.Event.Field   = String.  Alignment Field.
%                       Defaults to 'MemoryReachSaccade'
%               Params.Null.Field   = String.  Alignment field.
%                       Defaults to Params.Event.Field
%		Params.MaximumTimetoOnsetDetection = Scalar.  Duration after start of accumulation.
%  OVERWRITEFLAG = 0/1 Scalar.  Whether or not to overwrite.
%

global MONKEYDIR

if nargin < 2
  Params.Event.Target = 1;
  Params.MaximumTimetoOnsetDetection = 500;
  Params.TrialAvgdDetect = 0;
  Params.StartTimeOffset = -200;
end
if nargin < 3; OverwriteFlag = 0; end

Params.Selection = 'Reach';
Params.Type = '';

if isfield(Params,'Event')
  if isfield(Params.Event,'Task')
  else
    Params.Event.Task = 'MemoryReachSaccade';
  end
  if isfield(Params.Event,'Target')
  else
    error('No Params.Event.Target')
  end
  if isfield(Params.Event,'Field')
  else
    Params.Event.Field = 'SaccStart';
  end
end


if isfield(Params,'Null')
  if isfield(Params.Null,'Task')
  else
    Params.Null.Task = 'MemorySaccadeTouch';
  end
  if isfield(Params.Null,'Target')
  else
    Params.Null.Target = Params.Event.Target;
  end
  if isfield(Params.Null,'Field')
  else
    Params.Null.Field = Params.Event.Field;
  end
else
  Params.Null.Task =  'MemorySaccadeTouch';
  Params.Null.Field = Params.Event.Field;
  Params.Null.Target = Params.Event.Target;
end

Params.Null.Task
if isfield(Params,'MaximumTimetoOnsetDetection')
  MaxTime = Params.MaximumTimetoOnsetDetection;
else
  MaxTime = 500;
end

OffsetTime = Params.StartTimeOffset;
bn = [OffsetTime-50,OffsetTime+MaxTime+50]; %  Buffer analysis interval by 50ms windows for PSTH calculation
Params.StartofAccumulationTime = 50;

Params.Event.bn = bn;
Params.Null.bn = Params.Event.bn;


%  The following two lines are legacy - ignore
Params.compbound2 = 190; Params.MaxGLMOrder = 20;
Params.Hist = 0; Params.NoHist = 1; Params.VarNoHist = 0; 

SessionType = getSessionType(Session);
SessionNumberString = saveSessionNumberStringHelper(Session);

TaskString = [];
if iscell(Params.Event.Task)
    for iTask = 1:length(Params.Event.Task)
        TaskString = [TaskString '_' Params.Event.Task{iTask}];
    end
    TaskString = TaskString(2:end);
else
    TaskString = Params.Event.Task;
end
Filename = [MONKEYDIR '/mat/' SessionType '/' SessionType '_' Params.Selection 'Onset.' Params.Type '.' ...
    TaskString '.Dir' num2str(Params.Event.Target(1)) '.' SessionNumberString '.mat'];

FileFlag = exist(Filename, 'file');

if FileFlag && ~OverwriteFlag
    disp([Filename ' already saved.']);
    disp('Will not save. Overwrite flag is not set');
else
    switch SessionType
        case 'Spike'
            [Results,Data,Model] = loocalcReachOnsetS(Session,Params);
        case 'Field'
            error('Not yet implmented')
            %[Results,Data,Model] = loocalcReachOnsetF(Session,Params);
        case 'SpikeField'
            %[Results,Data,Model] = loocalcReachOnsetSF(Session,Params);
        case 'FieldField'
            %[Results,Data,Model] = loocalcReachOnsetFF(Session,Params);
        case 'SpikeSpike'
            %[Results,Data,Model] = loocalcReachOnsetSS(Session,Params);
    end

    ReachOnset.Results = Results;
    ReachOnset.Data = Data;
    ReachOnset.Model = Model;
    ReachOnset.Session = Session;
    ReachOnset.Params = Params;
    save(Filename, 'ReachOnset');
end

