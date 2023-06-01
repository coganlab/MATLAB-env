clear Params
Params.Selection = 'Decision';
Params.Type = 'Choice';

Params.Task = {'DelReachSaccade','DelSaccadeTouch','DelReachFix'};
Params.MaximumTimetoOnsetDetection = 1200;
Params.TrialAvgdDetect = 1;

Params.Hist = 0; Params.NoHist = 0; Params.VarNoHist = 0; 

Params.Spectral = 1;
Params.Lfp.Fk = [0,250];  %  Frequency range to keep
Params.Lfp.Dn = 0.005; 	% Time interval between estimates in s
Params.Lfp.Tapers = [0.1,10];	%  Spectral analysis params T (s) and W (Hz)
Params.Lfp.Df = 2;	% Step size between frequency bins to keep in Hz.

bn = [-100-Params.Lfp.Tapers(1)*1e3,Params.MaximumTimetoOnsetDetection+100]; 
Params.Event.Task = Params.Task; Params.Null.Task = Params.Task;
Params.Event.Field = 'TargsOn'; Params.Event.bn = bn;
Params.Null.Field = 'TargsOn'; Params.Null.bn = bn;
Params.StartofAccumulationTime = -bn(1);


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

