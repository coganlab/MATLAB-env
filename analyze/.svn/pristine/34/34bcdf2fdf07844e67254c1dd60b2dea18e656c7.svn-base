function Area = getBSArea(Session)
%
%  Area = getBSArea(Session)
%

Sess = splitSession(Session);
for iSess = 1:length(Sess)
  Type = getSessionType(Sess{iSess});
  eval(['Area{iSess} = getBSArea_' Type '(Sess{iSess});']);
end

% Type = getSessionType(Session);
% eval(['Area = getBSArea_' Type '(Session);']);

