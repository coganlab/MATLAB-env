clear Params
Params.Selection = 'Simple';
Params.Type = 'SaccStart';

Params.Task = {'MemorySaccadeTouch','MemoryReachSaccade'};
Params.MaximumTimetoOnsetDetection = 500;
Params.TrialAvgdDetect = 1;

bn = [-200,Params.MaximumTimetoOnsetDetection+100,1]; 
Params.Event.Task = Params.Task{1}; Params.Null.Task = Params.Task{2};
Params.Event.Field = 'SaccStart'; Params.Event.bn = bn;
Params.Null.Field = 'SaccStart'; Params.Null.bn = bn;
Params.StartofAccumulationTime = 100;% with respect to bn(1)

Params.NoHist = 1;

if iscell(Sess{1})
    for iSess = 1:length(Sess)
        Dirs = loadSessionDirections(Sess{iSess});
        
        Params.Event.Target(iSess) = Dirs.Null;
        Params.Null.Target(iSess) = Dirs.Null;
        Params.Subject{iSess} = MonkeyName;
    end
    Params.Label = 'PooledPopulation';
else
    Dirs = loadSessionDirections(Sess);
    
    Params.Event.Target = Dirs.Null;
    Params.Null.Target = Dirs.Null;
end

