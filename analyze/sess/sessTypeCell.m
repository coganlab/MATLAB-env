function SessionType = sessTypeCell(Session)
%
%  SessionType = sessTypeCell(Session)
%
%  SessionType = {'Spike'}, {'Field'}, {'Spike','Field'}, etc

if ~iscell(Session{1})
    Session = {Session};
end
for iSess = 1:length(Session)
    if ~iscell(Session{iSess}{8})
        Session{iSess}{8} = {Session{iSess}{8}};
    end
    nComponent = length(Session{iSess}{8});
    for iComponent = 1:nComponent
        SessionType{iSess,iComponent} = Session{iSess}{8}{iComponent};
        
    end
end