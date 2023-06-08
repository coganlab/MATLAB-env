function [newTable,ind] = limitTable(Table,Name,LimitStr,LimitType,ind)

%    newTable = limitTable(Table,Name,LimitStr,LimitType,ind)
%    Name - string - name of the column of interest, ie 'preGoFR'
%    LimitStr - string describing limit you want, ie '> 3'
%    if you want to put multiple limits on a Table, make Name and LimitStr
%    cells with each Name and Limit in order
%    LimitType allows us to OR strings instead of just AND
%    Example: goodTable = limitTable(Table,{'preGoFR','preGoFR'},{'>3','<20'},'&');
%    ind - can send in indexes to limit a table

if nargin < 4 || isempty(LimitType)
    LimitType = '&';
end
if nargin < 5; ind = []; end

newTable = Table;

if nargin < 5 || isempty(ind)
    if ~iscell(Name)
        Name = {Name};
    end
    if ~iscell(LimitStr)
        LimitStr = {LimitStr};
    end
    cmdstr = ('ind = find([newTable.Data.Values');
    for iLimit = 1:length(Name)
        Nameind = getTableIndex(newTable,Name{iLimit});
        cmdstr = ([cmdstr '{:,' num2str(Nameind) '}] ' LimitStr{iLimit}]);
        if iLimit < length(Name)
            cmdstr = ([cmdstr ' ' LimitType ' [newTable.Data.Values']);
        end
    end
    cmdstr = ([cmdstr ');']);
    eval(cmdstr)
end
newTable.Data.Values = newTable.Data.Values(ind,:);
newTable.Data.Sessions = newTable.Data.Sessions(ind);

