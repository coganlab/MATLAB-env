function ind = findSession(Session,SN)
%
%  ind = findSession(Session,SN)
%

for iSess = 1:length(Session)
    SessNums(iSess,:) = Session{iSess}{6};
end


if length(SN) == 2
    ind = find(SessNums(:,1)==SN(1) & SessNums(:,2)==SN(2));
end
