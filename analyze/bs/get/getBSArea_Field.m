function Area = getBSArea_Field(Session)
%
% Area = getBSArea_Field(Session)
%

global BSAREALIST

SN = getSessionNumbers(Session);

BSAreas = BSAreaFields;

ind = zeros(1,length(BSAREALIST));
for iArea = 1:length(BSAREALIST)
  ind(iArea) = length(find(BSAreas.(BSAREALIST{iArea})==SN));
end

if ~isempty(find(ind))
  Area = BSAREALIST{find(ind)};
else
  Area = 'Unlabeled';
end