function Value = calcSingleUnitS2(Session,CondParams,AnalParams)
%
%  Value = calcSingleUnitS2(Session,CondParams,AnalParams)
%  Should be sent a spike or multiunit session

SSess = splitSession(Session);

Type = getSessionType(SSess{2});
if strcmp(Type,'Spike')
    Value = 1;
else
    Value = 0;
end


