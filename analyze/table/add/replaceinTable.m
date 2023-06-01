function Table = replaceinTable(Table,Name,Type,CondParams,AnalParams)
%
%  Table = replaceinTable(Table,Name,Type,CondParams,AnalParams)
%

global MONKEYNAME MONKEYDIR

ind = getTableIndex(Table,Name);
if ~isempty(ind)
    if nargin < 3 || isempty(Type)
        Type = Table.Quantity(ind).Type; 
    end
    if nargin < 4 || isempty(CondParams)
        CondParams = Table.Quantity(ind).CondParams; 
    end
    if nargin < 5 || isempty(AnalParams)
        AnalParams = Table.Quantity(ind).AnalParams; 
    end
        
    NSess = length(Table.Data.Sessions);
    Values = Table.Data.Values;
    Table.Quantity(ind).CondParams = CondParams;
    Table.Quantity(ind).AnalParams = AnalParams;
    Table.Quantity(ind).Name = Name;
    Table.Quantity(ind).Type = Type;
    for iSess = 1:NSess
        disp(['iSess = ' num2str(iSess)])
        disp(['NSess = ' num2str(NSess)])
        tic
        Session = Table.Data.Sessions{iSess};
        MONKEYNAME = sessMonkeyName(Session);
        MONKEYDIR = ['/mnt/raid/' MONKEYNAME];
        eval(['Values{iSess,ind} = calcTable' Type '(Session,CondParams{iSess},AnalParams{iSess});']);
        toc
        close all
    end
    
    Table.Data.Values = Values;
else
    disp([Name ' not in Table'])
    %pause
end