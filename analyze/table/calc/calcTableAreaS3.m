function Value = calcAreaS3(Session,CondParams,AnalParams)
%
%  Value = calcAreaS3(Session,CondParams,AnalParams)


SSess = splitSession(Session);

Value = getBSArea(SSess{3});



