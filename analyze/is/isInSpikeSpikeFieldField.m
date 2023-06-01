function [flag,ind] = isInSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2,Session)
%
%  [flag,ind] = isInSpikeSpikeFieldField(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2,Session)
%

SN1 = sessNumber(SpikeSess1);
SN2 = sessNumber(SpikeSess2);
SN3 = sessNumber(FieldSess1);
SN4 = sessNumber(FieldSess2);

if isempty(Session)
    ind = [];
    flag = 0;
else
    A = getSessionNumbers(Session);
    ind = find((A(:,1)==SN1 & A(:,2)==SN2 & A(:,3)==SN3 & A(:,4)==SN4) | ...
        (A(:,1)==SN2 & A(:,2)==SN1 & A(:,3)==SN3 & A(:,4)==SN4) | ...
        (A(:,1)==SN1 & A(:,2)==SN2 & A(:,3)==SN4 & A(:,4)==SN3) | ...
        (A(:,1)==SN2 & A(:,2)==SN1 & A(:,3)==SN4 & A(:,4)==SN3));
    if ~isempty(ind)
        flag = 1;
    else
        flag = 0;
    end
end
