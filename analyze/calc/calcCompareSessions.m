function [same] = calcCompareSessions(Sessions1,Sessions2)

%  calcCompareSessions(Sessions1,Sessions2)
%
%  Performs a recursive comparison of the contents sets of Sessions
%  

same = 1;

if length(Sessions1)==length(Sessions2)
    for s=1:length(Sessions1)
        SN1 = Sessions1{s}{6};
        SN2 = Sessions2{s}{6};
        ST1 = getSessionType(Sessions1{s});
        ST2 = getSessionType(Sessions2{s});
        if length(SN1) == length(SN2) && strcmp(ST1,ST2)
            if ~(sum(SN1 == SN2) == length(SN1))
                same = 0; return;
            end
        else
            same = 0; return;
        end
    end
else
    same = 0; return;
end


