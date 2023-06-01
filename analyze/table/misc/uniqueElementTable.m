function newTable = uniqueElementTable(Table,Name)

%    newTable = uniqueElementTable(Table,Name,LimitStr)
%    Name - string - name of the column of interest, ie 'preGoFR'
%    Example: goodTable = uniqueElementTable(Table,{'SessNum1','SessNum2'});

newTable = Table;

if ~iscell(Name)
    Name = {Name};
end

for iCol = 1:length(Name)
    Values(:,iCol) = getColumnData(newTable,Name{iCol});
end

[~,ind,~] = unique(Values,'rows');

newTable.Data.Values = newTable.Data.Values(ind,:);
newTable.Data.Sessions = newTable.Data.Sessions(ind);


