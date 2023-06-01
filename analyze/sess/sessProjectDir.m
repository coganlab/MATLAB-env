function ProjectDir = sessProjectDir(Sessions)
% Return the ProjectDir field from an array of Sessions
%
%   ProjectDir = sessProjectDir(Sessions)
%

if ~iscell(Sessions{1})
  ProjectDir = Sessions{7};
else
  for iSess = 1:length(Sessions)
    ProjectDir{iSess} = Sessions{iSess}{7};
  end
end
