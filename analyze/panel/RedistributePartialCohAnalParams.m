function AnalParams = RedistributePartialCohAnalParams(AnalParams)
%
%  AnalParams = RedistributePartialCohAnalParams(AnalParams)
%


SubM = size(AnalParams,1) * 3;
SubN = size(AnalParams,2) * 2;
for iSubM = 1:SubM
    for iSubN = 1:SubN
        Sub = mod(iSubN+1,2) + 1;
        tAnalParams(iSubM,iSubN) = AnalParams(1,Sub);
    end
end

AnalParams = tAnalParams;