function Value = calcRRTS3(Session,CondParams,AnalParams)
%
%  Value = calcRRT(Session,CondParams,AnalParams)

SSess = splitSession(Session);
Sess = SSess{3};

All_Trials = sessTrials(Sess);
Trials = Params2Trials(All_Trials,CondParams);

Value = calcReachRT(Trials);



