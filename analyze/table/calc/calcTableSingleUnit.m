function Value = calcSingleUnit(Session,CondParams,AnalParams)
%
%  Value = calcSingleUnit(Session,CondParams,AnalParams)
%  Should be sent a spike or multiunit session


Type = getSessionType(Session);
if strcmp(Type,'Spike')
    Value = 1;
else
    Value = 0;
end


