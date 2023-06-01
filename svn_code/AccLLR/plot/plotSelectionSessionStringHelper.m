function SessionString = plotSelectionSessionStringHelper(Session)
%
%  SessionString = plotSelectionSessionStringHelper(Session)
%

if(iscell(Session{1}))
   SessionString = 'MultipleSessions'; 
else
    SessionString = [];
    for iSess = 1:length(Session{6})
        SessionString = [SessionString '.' num2str(Session{6}(iSess))];
    end
    SessionString = SessionString(2:end);
end

