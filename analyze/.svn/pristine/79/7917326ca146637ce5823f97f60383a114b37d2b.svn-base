function Recs = sessRec(Sessions)
% Return the Rec fields from an array of Sessions
%
%   Recs = sessRec(Sessions)
%

if ~iscell(Sessions{1})
  Recs = Sessions{2};
else
  for iSess = 1:length(Sessions)
    Recs(iSess) = Sessions{iSess}(2);
  end
end
