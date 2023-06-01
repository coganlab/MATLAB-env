function [flag,ind] = isInSpikeSpike(SpikeSess1,SpikeSess2,Session)
%
%  [flag,ind] = isInSpikeSpike(SpikeSess,SpikeSess,Session)
%

SN1 = sessNumber(SpikeSess1);
SN2 = sessNumber(SpikeSess2);

if ~isempty(Session)
    SessionNumbers = getSessionNumbers(Session);

    ind = find((SessionNumbers(:,1)==SN1 & SessionNumbers(:,2)==SN2) | ...
        (SessionNumbers(:,2)==SN1 & SessionNumbers(:,1)==SN2));
    if ~isempty(ind)
        flag = 1;
    else
        flag = 0;
    end
else
    ind = [];
    flag = 0;
end
