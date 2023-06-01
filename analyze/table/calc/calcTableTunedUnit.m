function Value = calcTunedUnit(Session,CondParams,AnalParams)
%
%  Value = calcTunedUnit(Session,CondParams,AnalParams)
%  Should be sent a spike or multiunit session

%Until I set up system for pulling up file
[p,~,~,~,~] = sessTestRateDiff(Session, CondParams{1}, CondParams{2});

%load up saved tuning information
if p<0.05
    Value = 1;
else
    Value = 0;
end



