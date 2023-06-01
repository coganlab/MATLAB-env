function Marker = snipMarker(Marker,Interval)
%
%  Marker = snipMarker(Marker,Interval)
%
%  Remove the segments of data with timestamps within [Interval.Start,Interval.Stop]
%

nCh = length(Marker);
nInterval = length(Interval);

for iCh = 1:nCh
    Interval_Tmp = Interval;
    for iInterval =1:nInterval
        sptimes = Marker{iCh}(1,:);
        ind1 =  find(sptimes < Interval_Tmp(iInterval).Start | sptimes > Interval_Tmp(iInterval).Stop);
        ind2 = find(sptimes > Interval_Tmp(iInterval).Stop);
        Marker{iCh}(1,ind2) = Marker{iCh}(1,ind2) - Interval_Tmp(iInterval).Duration;
        Marker{iCh} = Marker{iCh}(:,ind1);
        if iInterval < nInterval
            for iInterval2 = iInterval+1:nInterval
                Interval_Tmp(iInterval2).Start = Interval_Tmp(iInterval2).Start - Interval_Tmp(iInterval).Duration;
            end
        end
    end
end
