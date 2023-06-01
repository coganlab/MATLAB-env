function Value = calcSRTS1(Session,CondParams,AnalParams)
%
%  Value = calcSRT(Session,CondParams,AnalParams)

SSess = splitSession(Session);
Sess = SSess{1};

All_Trials = sessTrials(Sess);
Trials = Params2Trials(All_Trials,CondParams);

Value = calcSaccadeRT(Trials);



