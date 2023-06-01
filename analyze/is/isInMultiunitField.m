function [flag,ind] = isInMultiunitField(MultiunitSess,FieldSess,Session)
%
%  [flag,ind] = isInMultiunitField(MultiunitSess,FieldSess,Session)
%

SN1 = sessNumber(MultiunitSess);
SN2 = sessNumber(FieldSess);


if isempty(Session)
    ind = [];
    flag = 0;
else
    A = getSessionNumbers(Session);
    ind = find(A(:,1)==SN1 & A(:,2)==SN2);
    if ~isempty(ind)
        flag = 1;
    else
        flag = 0;
    end
end
