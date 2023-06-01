function Names = getColumns(Table)

%    Names = limitTable(Table)
%    Returns the column names


Names = {};
for iCol = 1:length(Table.Quantity)
    Names{iCol} = Table.Quantity(iCol).Name;
end