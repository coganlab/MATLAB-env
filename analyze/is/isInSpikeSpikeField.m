function [flag,ind] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session)
%
%  [flag,ind] = isInSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess,Session)
%

SN1 = sessNumber(SpikeSess1);
SN2 = sessNumber(SpikeSess2);
SN3 = sessNumber(FieldSess);


if isempty(Session)
    ind = [];
    flag = 0;
else
  A = getSessionNumbers(Session);
    ind = find((A(:,1)==SN1 & A(:,2)==SN2 & A(:,3)==SN3) | ...
        (A(:,1)==SN2 & A(:,2)==SN1 & A(:,3)==SN3));
        if ~isempty(ind)
        flag = 1;
    else
        flag = 0;
    end
end
