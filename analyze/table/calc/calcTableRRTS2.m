function Value = calcRRTS2(Session,CondParams,AnalParams)
%
%  Value = calcRRT(Session,CondParams,AnalParams)

SSess = splitSession(Session);
Sess = SSess{2};

All_Trials = sessTrials(Sess);
Trials = Params2Trials(All_Trials,CondParams);

Value = calcReachRT(Trials);



