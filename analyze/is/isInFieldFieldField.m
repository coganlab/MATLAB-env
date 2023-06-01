function [flag,ind] = isInFieldFieldField(FieldSess1,FieldSess2,FieldSess3,Session)
%
%  [flag,ind] = isInFieldFieldField(FieldSess1,FieldSess2,FieldSess3,Session)
%

SN1 = sessNumber(FieldSess1);
SN2 = sessNumber(FieldSess2);
SN3 = sessNumber(FieldSess3);

if isempty(Session)
    flag = 0;
    ind = 1;
else
    A = getSessionNumbers(Session);
    
    if isempty(Session)
        ind = [];
        flag = 0;
    else
        ind = find((A(:,1)==SN1 & A(:,2)==SN2 & A(:,3)==SN3) | ...
            (A(:,1)==SN1 & A(:,2)==SN3 & A(:,3)==SN2) | ...
            (A(:,1)==SN2 & A(:,2)==SN3 & A(:,3)==SN1) | ...
            (A(:,1)==SN2 & A(:,2)==SN1 & A(:,3)==SN3) | ...
            (A(:,1)==SN3 & A(:,2)==SN1 & A(:,3)==SN2) | ...
            (A(:,1)==SN3 & A(:,2)==SN2 & A(:,3)==SN1));
        if ~isempty(ind)
            flag = 1;
        else
            flag = 0;
        end
    end
end
