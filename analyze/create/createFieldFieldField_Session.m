function FieldFieldFieldSession = createFieldFieldField_Session(FieldSess1,FieldSess2,FieldSess3)
%
%   FieldFieldFieldSession = createFieldFieldField_Session(FieldSess1,FieldSess2,FieldSess3)
%
%   Inputs:
%     FieldSess1 = Cell array. A Field Session
%     FieldSess2 = Cell array. A Field Session
%     FieldSess3 = Cell array. A Field Session
%
%  Outputs: 
%    FieldFieldFieldSession = Cell array.  The corresponding Field-Field-Field session
%

SessNum1 = FieldSess1{6};
SessNum2 = FieldSess2{6};
SessNum3 = FieldSess3{6};

MonkeyName1 = sessMonkeyName(FieldSess1);
MonkeyName2 = sessMonkeyName(FieldSess2);
MonkeyName3 = sessMonkeyName(FieldSess3);

MonkeyName = MonkeyName1;

[Y,I] = sort([SessNum1 SessNum2 SessNum3]);
SessNum1 = Y(1);
SessNum2 = Y(2);
SessNum3 = Y(3);
FieldSess{1} = FieldSess1;
FieldSess{2} = FieldSess2;
FieldSess{3} = FieldSess3;

FieldSess1 = FieldSess{I(1)};
FieldSess2 = FieldSess{I(2)};
FieldSess3 = FieldSess{I(3)};

tmpSession = cell(0,0);
tmpSession(1) = intersect(intersect(FieldSess1(1),FieldSess2(1)),intersect(FieldSess1(1),FieldSess3(1)));
tmpSession{2} = intersect(intersect(FieldSess1{2},FieldSess2{2}),intersect(FieldSess1{2},FieldSess3{2}));
tmpSession{3}{1} = sessTower(FieldSess1);
tmpSession{3}{2} = sessTower(FieldSess2);
tmpSession{3}{3} = sessTower(FieldSess3);
Contact = sessContact(FieldSess1);
tmpSession{4}{1} = {sessElectrode(FieldSess1),Contact(1)};
Contact = sessContact(FieldSess2);
tmpSession{4}{2} = {sessElectrode(FieldSess2),Contact(1)};
Contact = sessContact(FieldSess3);
tmpSession{4}{3} = {sessElectrode(FieldSess3),Contact(1)};
if iscell(FieldSess1{5})
    if iscell(FieldSess2{5})
        if iscell(FieldSess3{5})
            tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5}{1},FieldSess3{5}{1}};
        elseif ~iscell(FieldSess3{5})
            tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5}{1},FieldSess3{5}};
        end
    elseif ~iscell(FieldSess2{5})
        if iscell(FieldSess3{5})
            tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5},FieldSess3{5}{1}};
        elseif ~iscell(FieldSess2{5})
            tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5},FieldSess3{5}};
        end
    end
elseif ~iscell(FieldSess1{5})
    if iscell(FieldSess2{5})
        if iscell(FieldSess3{5})
            tmpSession{5} = {FieldSess1{5},FieldSess2{5}{1},FieldSess3{5}{1}};
        elseif ~iscell(FieldSess3{5})
            tmpSession{5} = {FieldSess1{5},FieldSess2{5}{1},FieldSess3{5}};
        end
    elseif ~iscell(FieldSess2{5})
        if iscell(FieldSess3{5})
            tmpSession{5} = {FieldSess1{5},FieldSess2{5},FieldSess3{5}{1}};
        elseif ~iscell(FieldSess2{5})
            tmpSession{5} = {FieldSess1{5},FieldSess2{5},FieldSess3{5}};
        end
    end
end
tmpSession{6} = [SessNum1,SessNum2,SessNum3];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Field','Field','Field'};

FieldFieldFieldSession = tmpSession;



