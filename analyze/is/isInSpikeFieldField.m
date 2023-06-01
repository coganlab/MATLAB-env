function [flag,ind] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session)
%
%  [flag,ind] = isInSpikeFieldField(SpikeSess,FieldSess1,FieldSess2,Session)
%

SN1 = sessNumber(SpikeSess);
SN2 = sessNumber(FieldSess1);
SN3 = sessNumber(FieldSess2);


if isempty(Session)
    ind = [];
    flag = 0;
else
    A = getSessionNumbers(Session);
    ind = find((A(:,1)==SN1 & A(:,2)==SN2 & A(:,3)==SN3) | ...
        (A(:,1)==SN1 & A(:,2)==SN3 & A(:,3)==SN2));
    if ~isempty(ind)
        flag = 1;
    else
        flag = 0;
    end
end
