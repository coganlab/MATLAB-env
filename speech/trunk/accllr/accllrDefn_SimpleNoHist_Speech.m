clear Params
Params.Selection = 'Simple';
Params.Type = 'Auditory';

Params.Task = {'Speech'};
Params.MaximumTimetoOnsetDetection = 500;
Params.TrialAvgdDetect = 1;
Params.SessionCount = 1;
Params.NoHist = 1;

bn = [-50,Params.MaximumTimetoOnsetDetection+50]; 
Params.Event.Task = Params.Task; Params.Null.Task = Params.Task;
Params.Event.Field = 'Auditory'; Params.Event.bn = bn;
Params.Null.Field = 'Auditory'; Params.Null.bn = bn;
Params.StartofAccumulationTime = -bn(1);


