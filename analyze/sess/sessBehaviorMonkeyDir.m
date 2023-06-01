function MonkeyDir = sessBehaviorMonkeyDir(Sessions)
% Return the Day field from an array of Behavior Sessions
%
%   MonkeyDir = sessBehaviorMonkeyDir(Sessions)
%

if ~iscell(Sessions{1})
  MonkeyDir = Sessions{5};
else
  for iSess = 1:length(Sessions)
    MonkeyDir{iSess} = Sessions{iSess}{5};
  end
end
