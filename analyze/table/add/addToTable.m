function Table = addToTable(Table,Name,Type,CondParams,AnalParams)
%
%  Table = addToTable(Table,Name,Type,CondParams,AnalParams)
%

global MONKEYNAME MONKEYDIR


ind = getTableIndex(Table,Name);
if isempty(ind)
    NSess = length(Table.Data.Sessions);
    NValues = length(Table.Quantity);
    iValue = NValues + 1;
    Values = Table.Data.Values;
    Table.Quantity(iValue).CondParams = CondParams;
    Table.Quantity(iValue).AnalParams = AnalParams;
    Table.Quantity(iValue).Name = Name;
    Table.Quantity(iValue).Type = Type;
    for iSess = 1:NSess
        disp(['iSess = ' num2str(iSess)])
        disp(['NSess = ' num2str(NSess)])
        tic
        Session = Table.Data.Sessions{iSess};
        MONKEYNAME = sessMonkeyName(Session);
        MONKEYDIR = ['/mnt/raid/' MONKEYNAME];
        eval(['Values{iSess,iValue} = calcTable' Type '(Session,CondParams{iSess},AnalParams{iSess});']);
        toc
        close all
    end
    
    Table.Data.Values = Values;
else
    disp('Already in Table')
end