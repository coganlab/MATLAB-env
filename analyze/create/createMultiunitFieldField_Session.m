function MultiunitFieldFieldSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2)
%
%   MultiunitFieldFieldSession = createMultiunitFieldField_Session(MultiunitSess,FieldSess1,FieldSess2)
%
%   Inputs:
%     MultiunitSess = Cell array. A Multiunit Session
%     FieldSess1 = Cell array. A Field Session
%     FieldSess2 = Cell array. A Field Session
%
%  Outputs: 
%    MultiunitFieldFieldSession = Cell array.  The corresponding Multiunit-Field-Field session
%

SessNum1 = MultiunitSess{6};
SessNum2 = FieldSess1{6};
SessNum3 = FieldSess2{6};

MonkeyName = sessMonkeyName(MultiunitSess);

if SessNum2 > SessNum3
    tmp = FieldSess1;
    FieldSess1 = FieldSess2;
    FieldSess2 = tmp;
    SessNum2 = FieldSess1{6};
    SessNum3 = FieldSess2{6};
end

tmpSession = cell(0,0);
tmpSession(1) = intersect(intersect(MultiunitSess(1),FieldSess1(1)),intersect(MultiunitSess(1),FieldSess2(1)));
tmpSession{2} = intersect(intersect(MultiunitSess{2},FieldSess1{2}),intersect(MultiunitSess{2},FieldSess2{2}));
tmpSession{3}{1} = sessTower(MultiunitSess);
tmpSession{3}{2} = sessTower(FieldSess1);
tmpSession{3}{3} = sessTower(FieldSess2);
Contact=  sessContact(MultiunitSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{1} = {sessElectrode(MultiunitSess),Contact{1}};
Contact=  sessContact(FieldSess1);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{2} = {sessElectrode(FieldSess1),Contact{1}};
Contact=  sessContact(FieldSess2);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{3} = {sessElectrode(FieldSess2),Contact{1}};
if iscell(MultiunitSess{5})
    if iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {MultiunitSess{5}{1},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {MultiunitSess{5}{1},FieldSess1{5}{1},FieldSess2{5}};
        end
    elseif ~iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {MultiunitSess{5}{1},FieldSess1{5},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {MultiunitSess{5}{1},FieldSess1{5},FieldSess2{5}};
        end
    end
elseif ~iscell(MultiunitSess{5})
    if iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess1{5}{1},FieldSess2{5}};
        end
    elseif ~iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess1{5},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess1{5},FieldSess2{5}};
        end
    end
end
tmpSession{6} = [SessNum1,SessNum2,SessNum3];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Multiunit','Field','Field'};

MultiunitFieldFieldSession = tmpSession;



