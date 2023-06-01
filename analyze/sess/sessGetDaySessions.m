function DaySession = sessGetDaySessions(Session,Day)
%
%  DaySession = sessGetDaySessions(Session,Day)
%

Days = cell(1,length(Session));
for iSess = 1:length(Session)
    if ischar(Session{iSess}{1})
        Days{iSess} = Session{iSess}{1};
    else
        Days{iSess} = Session{iSess}(1).Day;
    end
end

DaySession = Session(strcmp(Days,Day));
