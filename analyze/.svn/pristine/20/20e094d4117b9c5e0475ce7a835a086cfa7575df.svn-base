function [flag,ind] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session)
%
%  [flag,ind] = isInMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess,Session)
%

SN1 = sessNumber(MultiunitSess1);
SN2 = sessNumber(MultiunitSess2);
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
