function Days = sessDay(Sessions)
% Return the Day field from an array of Sessions
%
%   Days = sessDay(Sessions)
%


if ~iscell(Sessions{1})
  Days = Sessions{1};
else
    Days = cell(1,length(Sessions));
  for iSess = 1:length(Sessions)
    Days{iSess} = Sessions{iSess}{1};
  end
end
