function ind = getTableIndex(Table,Name)

%  ind = getTableIndex(Table,Name)
%  When sent a name from the table, returns the index

ind = [];
for iName = 1:length(Table.Quantity)
    if strcmp(Name,Table.Quantity(iName).Name)
        ind = iName;
    end
end

if isempty(ind)
    disp('Name not found in Table')
end