function Pk = snipPk(Pk,Interval)
%
%  Pk = snipPk(Pk,Interval)
%

nCh = length(Pk);
nInterval = length(Interval);

for iCh = 1:nCh
    Interval_Tmp = Interval;
    for iInterval =1:nInterval
        sptimes = Pk{iCh}(:,1);
        ind1 =  find(sptimes < Interval_Tmp(iInterval).Start | sptimes > Interval_Tmp(iInterval).Stop);
        ind2 = find(sptimes > Interval_Tmp(iInterval).Stop);
        Pk{iCh}(ind2,1) = Pk{iCh}(ind2,1) - Interval_Tmp(iInterval).Duration;
        %Pk{iCh} = Pk{iCh}(ind1,1);
        Pk{iCh} = Pk{iCh}(ind1,:);
        if iInterval < nInterval
            for iInterval2 = iInterval+1:nInterval
                Interval_Tmp(iInterval2).Start = Interval_Tmp(iInterval2).Start - Interval_Tmp(iInterval).Duration;
            end
        end
    end
end
