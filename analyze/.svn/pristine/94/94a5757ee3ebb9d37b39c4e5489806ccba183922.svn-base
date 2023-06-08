clear Params
Params.Selection = 'Simple';
Params.Type = 'Visual';

Params.Task = {'MemoryReachSaccade'};
Params.MaximumTimetoOnsetDetection = 400;
Params.TrialAvgdDetect = 0;
Params.StartTime = -200;
Params.StartofAccumulationTime = 200;

bn = [Params.StartTime,Params.MaximumTimetoOnsetDetection+100]; 
Params.Event.Task = Params.Task; Params.Null.Task = Params.Task;
Params.Event.Field = 'TargsOn'; Params.Event.bn = bn;
Params.Null.Field = 'TargsOn'; Params.Null.bn = bn;

Params.Hist = 0; Params.NoHist = 0; Params.VarNoHist = 0; 

Params.Spectral = 1;
Params.Lfp.Fk = 200; 
Params.Lfp.Dn = 0.002; 
Params.Lfp.Tapers = [0.24,30];
Params.Lfp.Df = 2;

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

