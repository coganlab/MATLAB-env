function tmpSession = createMultiunitField_Session(MultiunitSess,FieldSess)
%
%   tmpSession = createMultiunitField_Session(MultiunitSess,FieldSess)
%

SessNum1 = sessNumber(MultiunitSess);
SessNum2 = sessNumber(FieldSess);
MonkeyName1 = sessMonkeyDir(MultiunitSess);
MonkeyName2 = sessMonkeyDir(FieldSess);
if strcmp(MonkeyName1,MonkeyName2)
    MonkeyName = MonkeyName1;
else
    error('Sessions must be from same MONKEYDIR');
end

tmpSession = cell(0,0);
tmpSession(1) = intersect(MultiunitSess(1),FieldSess(1));
tmpSession{2} = intersect(MultiunitSess{2},FieldSess{2});
tmpSession{3}{1} = sessTower(MultiunitSess);
tmpSession{3}{2} = sessTower(FieldSess);
Contact = sessContact(MultiunitSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{1} = {sessElectrode(MultiunitSess),Contact{1}};
Contact= sessContact(FieldSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{2} = {sessElectrode(FieldSess),Contact{1}};
if iscell(MultiunitSess{5})
    if iscell(FieldSess{5})
        tmpSession{5} = {MultiunitSess{5}{1},FieldSess{5}{1}};
    else
        tmpSession{5} = {MultiunitSess{5}{1},FieldSess{5}};
    end
elseif ~iscell(MultiunitSess{5})
    if iscell(FieldSess{5})
        tmpSession{5} = {MultiunitSess{5},FieldSess{5}{1}};
    else
        tmpSession{5} = {MultiunitSess{5},FieldSess{5}};
    end
end
tmpSession{6} = [SessNum1,SessNum2];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Multiunit','Field'};

