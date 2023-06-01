function [flag,ind] = isInFieldField(FieldSess1,FieldSess2,Session)
%
%  [flag,ind] = isInFieldField(FieldSess1,FieldSess2,Session)
%
%   FLAG is 1 if the Field-Field session indicated by FieldSess1 and
%   FieldSess2 is in Session.
%
SN1 = sessNumber(FieldSess1);
SN2 = sessNumber(FieldSess2);

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
    flag = 0;
    ind = [];
end
