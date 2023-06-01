function Joint = snipJoint(Joint,Interval)
%
%  Joint = snipJoint(Joint,Interval)
%

nCh = length(Joint);
nInterval = length(Interval);

for iCh = 1:nCh
    Interval_Tmp = Interval;
    for iInterval =1:nInterval
        sptimes = Joint{iCh}(1,:);
        ind1 =  find(sptimes < Interval_Tmp(iInterval).Start | sptimes > Interval_Tmp(iInterval).Stop);
        ind2 = find(sptimes > Interval_Tmp(iInterval).Stop);
        Joint{iCh}(1,ind2) = Joint{iCh}(1,ind2) - Interval_Tmp(iInterval).Duration;
        Joint{iCh} = Joint{iCh}(:,ind1);
        if iInterval < nInterval
            for iInterval2 = iInterval+1:nInterval
                Interval_Tmp(iInterval2).Start = Interval_Tmp(iInterval2).Start - Interval_Tmp(iInterval).Duration;
            end
        end
    end
end
