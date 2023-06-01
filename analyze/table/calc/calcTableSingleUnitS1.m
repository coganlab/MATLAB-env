function Value = calcSingleUnitS1(Session,CondParams,AnalParams)
%
%  Value = calcSingleUnitS1(Session,CondParams,AnalParams)
%  Should be sent a spike or multiunit session

SSess = splitSession(Session);

Type = getSessionType(SSess{1});
if strcmp(Type,'Spike')
    Value = 1;
else
    Value = 0;
end


