function Table = mergeTables(Table1, Table2)
%
%  Table = mergeTables(Table1, Table2)
%
%  Checks that all sessions are the same.
%  If so, goes through and adds all unduplicated columns
%  If not, checks to see if columns are the same.
%  If so, goes through and adds all unduplicated sessions


if calcCompareSessions(Table1.Data.Sessions,Table2.Data.Sessions)
    Table = Table1;
    ind = length(Table1.Quantity);
    for iQuantity = 1:length(Table2.Quantity)
        Name = Table2.Quantity(iQuantity).Name;
        T2Ind = getTableIndex(Table1,Name);
        if isempty(T2Ind)
            ind = ind + 1;
            Table.Quantity(ind).Type = Table.Quantity(iQuantity).Type;
            Table.Quantity(ind).CondParams = Table.Quantity(iQuantity).CondParams;
            Table.Quantity(ind).AnalParams = Table.Quantity(iQuantity).AnalParams;
            Table.Quantity(ind).Name = Name;
            for iSess = 1:length(Table.Data.Sessions)
                Table.Data.Values{iSess,ind} = Table2.Data.Values{iSess,iQuantity};
            end
        end
    end
    Table.CondParams.Name = [Table1.CondParams.Name Table2.CondParams.Name];
else
    % Check for same names, different sessions
    Table = Table1;
    if length(Table1.Quantity) == length(Table2.Quantity)
        same = 1;
        for i = 1:length(Table1.Quantity)
            T1 = Table1.Quantity(i);
            T2 = Table2.Quantity(i);
            T1.CondParams = []; T2.CondParams = [];
            T1.AnalParams = []; T2.AnalParams = [];
            if ~calcCompareStructures(T1,T2)
                same = 0;
            end
        end
        if same
            %Go through sessions and add new ones
            SN = getSessionNumbers(Table1.Data.Sessions);
            ind = length(Table.Data.Sessions);
            for iSess = 1:length(Table2.Data.Sessions)
                SessNum = getSessionNumbers(Table2.Data.Sessions{iSess});
                if isempty(find(SN(:,1)==SessNum(1) & SN(:,2)==SessNum(2) & SN(:,3)==SessNum(3), 1))
                    ind = ind + 1;
                    for iCol = 1:length(Table.Quantity)
                        Table.Quantity(iCol).CondParams{ind} = Table2.Quantity(iCol).CondParams{iSess};
                        Table.Quantity(iCol).AnalParams{ind} = Table2.Quantity(iCol).AnalParams{iSess};
                        Table.Data.Values{ind,iCol} = Table2.Data.Values{iSess,iCol};
                    end
                    Table.Data.Sessions{ind} = Table2.Data.Sessions{iSess};
                    Table.Data.Monkey{ind} = Table2.Data.Monkey{iSess};
                end
            end
        else
            disp('Neither sessions nor quantities match.')
            Table = [];
        end
    else
        disp('Neither sessions nor quantities match.')
        Table = [];
    end
end

