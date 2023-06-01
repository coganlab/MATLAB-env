function Channels = sessChannel(Sessions)
% Return the Channel fields from an array of Sessions
%
%   Channels = sessChannel(Sessions)
%


if ~iscell(Sessions{1})
  Channels = Sessions{4};
else
  for iSess = 1:length(Sessions)
    Channels(iSess,:) = Sessions{iSess}{4};
  end
end
