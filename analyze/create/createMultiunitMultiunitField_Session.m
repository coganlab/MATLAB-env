function MultiunitMultiunitFieldSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess)
%
%   MultiunitMultiunitFieldSession = createMultiunitMultiunitField_Session(MultiunitSess1,MultiunitSess2,FieldSess)
%
%   Inputs:
%     MultiunitSess1 = Cell array. A Multiunit Session
%     MultiunitSess2 = Cell array. A Multiunit Session
%     FieldSess = Cell array. A Field Session
%
%  Outputs: 
%    MultiunitMultiunitFieldSession = Cell array.  The corresponding Multiunit-Multiunit-Field session
%

SessNum1 = MultiunitSess1{6};
SessNum2 = MultiunitSess2{6};
SessNum3 = FieldSess{6};

MonkeyName = sessMonkeyName(MultiunitSess1);

if SessNum1 > SessNum2
    tmp = MultiunitSess1;
    MultiunitSess1 = MultiunitSess2;
    MultiunitSess2 = tmp;
    SessNum1 = MultiunitSess1{6};
    SessNum2 = MultiunitSess2{6};
end

tmpSession = cell(0,0);
tmpSession(1) = intersect(intersect(MultiunitSess1(1),MultiunitSess2(1)),intersect(MultiunitSess1(1),FieldSess(1)));
tmpSession{2} = intersect(intersect(MultiunitSess1{2},MultiunitSess2{2}),intersect(MultiunitSess1{2},FieldSess{2}));
tmpSession{3}{1} = sessTower(MultiunitSess1);
tmpSession{3}{2} = sessTower(MultiunitSess2);
tmpSession{3}{3} = sessTower(FieldSess);
Contact = sessContact(MultiunitSess1);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{1} = {sessElectrode(MultiunitSess1),Contact{1}};
Contact = sessContact(MultiunitSess2);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{2} = {sessElectrode(MultiunitSess2),Contact{1}};
Contact= sessContact(FieldSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{3} = {sessElectrode(FieldSess),Contact{1}};

if iscell(MultiunitSess1{5})
    if iscell(MultiunitSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess1{5}{1},MultiunitSess2{5}{1},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess2{5})
            tmpSession{5} = {MultiunitSess1{5}{1},MultiunitSess2{5}{1},FieldSess{5}};
        end
    elseif ~iscell(MultiunitSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess1{5}{1},MultiunitSess2{5},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess2{5})
            tmpSession{5} = {MultiunitSess1{5}{1},MultiunitSess2{5},FieldSess{5}};
        end
    end
elseif ~iscell(MultiunitSess1{5})
    if iscell(MultiunitSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5}{1},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess2{5})
            tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5}{1},FieldSess{5}};
        end
    elseif ~iscell(MultiunitSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess2{5})
            tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5},FieldSess{5}};
        end
    end
end
tmpSession{6} = [SessNum1,SessNum2,SessNum3];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Multiunit','Multiunit','Field'};


MultiunitMultiunitFieldSession = tmpSession;



