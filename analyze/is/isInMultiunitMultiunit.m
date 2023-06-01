function [flag,ind] = isInMultiunitMultiunit(MultiunitSess1,MultiunitSess2,Session)
%
%  [flag,ind] = isInSpikeSpike(SpikeSess,SpikeSess,Session)
%

SN1 = sessNumber(MultiunitSess1);
SN2 = sessNumber(MultiunitSess2);

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



