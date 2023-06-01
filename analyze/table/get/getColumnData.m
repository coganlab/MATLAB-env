function [myValue,ind] = getColumnData(Table,Name)

%  Value = getColumnData(Table,Name)
%  When sent a name from the table, returns the column in Value 
%  and index of the column in ind

ind = [];
for iName = 1:length(Table.Quantity)
    if strcmp(Name,Table.Quantity(iName).Name)
        ind = iName;
    end
end

if isempty(ind)
    disp('Name not found in Table')
    myValue = [];
else
    for iSess = 1:length(Table.Data.Sessions)
        if ~isempty(Table.Data.Values{iSess,ind})
            if size(size(Table.Data.Values{iSess,ind}),2) == 3
                myValue(iSess,:,:) = mean(Table.Data.Values{iSess,ind});
            else
                myValue(iSess,:,:) = Table.Data.Values{iSess,ind};
            end
        else
            myValue(iSess,:,:) = NaN;
        end
    end
end

    
 