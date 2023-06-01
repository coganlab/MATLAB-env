function Depths = sessDepthField(Sessions)
% Return the Depth fields from an array of Sessions
%
%   Depths = sessDepth(Sessions)
%


if ~iscell(Sessions{1})
  Depths = Sessions{5}{1};
else
  for iSess = 1:length(Sessions)
    Depths(iSess,:) = Sessions{iSess}{5}{1};
  end
end
