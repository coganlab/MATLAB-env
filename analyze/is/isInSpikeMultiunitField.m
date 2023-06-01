function [flag,ind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session)
%
%  [flag,ind] = isInSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess,Session)
%

SN1 = SpikeSess{6};
SN2 = MultiunitSess{6};
SN3 = FieldSess{6};

A = getSessionNumbers(Session);

if isempty(Session)
    ind = [];
    flag = 0;
else
    ind = find((A(:,1)==SN1 & A(:,2)==SN2 & A(:,3)==SN3));
    if ~isempty(ind)
        flag = 1;
    else
        flag = 0;
    end
end
