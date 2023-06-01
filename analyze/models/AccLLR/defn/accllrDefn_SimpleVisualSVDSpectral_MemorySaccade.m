clear Params
Params.Selection = 'Simple';
Params.Type = 'Visual';

Params.Task = {'MemorySaccade','DelayedSaccade'};
Params.MaximumTimetoOnsetDetection = 1900;
Params.StartTime = 300;
Params.TrialAvgdDetect = 0;
Params.StartofAccumulationTime = 300;

bn = [Params.StartTime,Params.MaximumTimetoOnsetDetection]; 
Params.Event.Task = Params.Task; Params.Null.Task = Params.Task;
Params.Event.Field = 'TargsOn'; Params.Event.bn = bn;
Params.Null.Field = 'TargsOn'; Params.Null.bn = bn;

Params.Hist = 0; Params.NoHist = 0; Params.VarNoHist = 0; 

Params.SVDSpectral = 1;
Params.Lfp.Fk = 300; % 250; 
Params.Lfp.Dn = 0.1; 
Params.Lfp.Tapers = [0.4,20];
Params.Lfp.Df = 2;
Params.Lfp.Modes = 30; % 20;

if ~exist('Dirs','var') || isempty(Dirs)
    if iscell(Sess{1})
        for iSess = 1:length(Sess)
            Dirs = loadSessionDirections(Sess{iSess});
            
            Params.Event.Target(iSess) = Dirs.Pref;
            Params.Null.Target(iSess) = Dirs.Null;
            Params.Subject{iSess} = MonkeyName;
        end
        Params.Label = 'PooledPopulation';
    else
        Dirs = loadSessionDirections(Sess);
        
        Params.Event.Target = Dirs.Pref;
        Params.Null.Target = Dirs.Null;
    end
else
    Params.Event.Target = Dirs.Pref;
    Params.Null.Target = Dirs.Null;
end