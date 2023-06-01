function TypeString = plotSelectionTypeStringHelper(Results)
%
%  TypeString = plotSelectionTypeStringHelper(Results)
%

TypeString = [];
for iType = 1:length(Results)
  TypeString = [TypeString ' ' Results(iType).Type];
end
TypeString = TypeString(2:end);

