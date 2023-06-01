function MonkeyName = sessMonkeyName(Sessions)
% Return the Day field from an array of Sessions
%
%   MonkeyName = sessMonkeyName(Sessions)
%

if ~iscell(Sessions{1})
  MonkeyName = Sessions{7};
else
  for iSess = 1:length(Sessions)
    MonkeyName{iSess} = Sessions{iSess}{7};
  end
end
