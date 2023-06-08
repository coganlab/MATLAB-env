function Table = createTable(Table)
%
%  Table = createTable(Table)
%

global MONKEYNAME MONKEYDIR

NSess = length(Table.Data.Sessions);
NValues = length(Table.Quantity);
Values = [];
for iSess = 1:NSess
    disp(['iSess = ' num2str(iSess)])
    disp(['NSess = ' num2str(NSess)])
    tic
    Session = Table.Data.Sessions{iSess};
    MONKEYNAME = sessMonkeyName(Session);
    MONKEYDIR = ['/mnt/raid/' MONKEYNAME];
    for iValue = 1:NValues
        Type = Table.Quantity(iValue).Type;
        SubCondParams = Table.Quantity(iValue).CondParams{iSess};
        SubAnalParams = Table.Quantity(iValue).AnalParams{iSess};
        eval(['Values{iSess,iValue} = calcTable' Type '(Session,SubCondParams,SubAnalParams);']);
    end
    toc
    close all
end

Table.Data.Values = Values;

