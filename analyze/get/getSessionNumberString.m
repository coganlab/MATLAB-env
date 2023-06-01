function SessionNumberString = getSessionNumberString(Session)
%
%  SessionNumberString = getSessionNumberString(Session)
%

SessionNumbers = Session{6};

SessionNumberString = '';

for iSess = 1:length(SessionNumbers)
    SessionNumberString = [SessionNumberString '_' num2str(SessionNumbers(iSess))];
end
SessionNumberString = SessionNumberString(2:end);