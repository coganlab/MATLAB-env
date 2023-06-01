function [flag,ind] = isInSpikeMultiunit(SpikeSess,MultiunitSess,Session)
%
%  [flag,ind] = isInSpikeMultiunit(SpikeSess,MultiunitSess,Session)
%

SN1 = sessNumber(SpikeSess);
SN2 = sessNumber(MultiunitSess);

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



