clear Params
Params.Selection = 'Decision';
Params.Type = 'Choice';

Params.Task = {{'DelReachSaccade','DelSaccadeTouch','DelReachFix'}};
Params.MaximumTimetoOnsetDetection = 1000;
Params.TrialAvgdDetect = 1;

bn = [-200,Params.MaximumTimetoOnsetDetection+100]; 
Params.Event.Task = Params.Task; Params.Null.Task = Params.Task;
Params.Event.Field = 'TargsOn'; Params.Event.bn = bn;
Params.Null.Field = 'TargsOn'; Params.Null.bn = bn;
Params.StartofAccumulationTime = -bn(1);

% Params.compbound2 = 190; Params.MaxGLMOrder = 20;
Params.Hist = 0; Params.NoHist = 1; Params.VarNoHist = 0; 

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

