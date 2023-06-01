function MultiunitMultiunitSession = createMultiunitMultiunit_Session(MultiunitSess1,MultiunitSess2)
%
%   MultiunitMultiunitSession = createMultiunitMultiunit_Session(MultiunitSess,MultiunitSess)
%

SessNum1 = MultiunitSess1{6};
SessNum2 = MultiunitSess2{6};

MonkeyName1 = sessMonkeyName(MultiunitSess1);
MonkeyName2 = sessMonkeyName(MultiunitSess2);
if strcmp(MonkeyName1,MonkeyName2)
  MonkeyName = MonkeyName1;
else
  error('Sessions must be form same MONKEYNAME');
end

if SessNum1 > SessNum2
    tmp = MultiunitSess1;
    MultiunitSess1 = MultiunitSess2;
    MultiunitSess2 = tmp;
    SessNum1 = MultiunitSess1{6};
    SessNum2 = MultiunitSess2{6};
end

tmpSession = cell(0,0);
tmpSession(1) = intersect(MultiunitSess1(1),MultiunitSess2(1));
tmpSession{2} = intersect(MultiunitSess1{2},MultiunitSess2{2});
tmpSession{3}{1} = sessTower(MultiunitSess1);
tmpSession{3}{2} = sessTower(MultiunitSess2);
Contact= sessContact(MultiunitSess1);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{1} = {sessElectrode(MultiunitSess1),Contact{1}};
Contact=  sessContact(MultiunitSess2);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{2} = {sessElectrode(MultiunitSess2),Contact{1}};
if iscell(MultiunitSess1{5})
    if iscell(MultiunitSess2{5})
    tmpSession{5} = {MultiunitSess1{5}{1},MultiunitSess2{5}{1}};
    else
    tmpSession{5} = {MultiunitSess1{5}{1},MultiunitSess2{5}};
    end
elseif ~iscell(MultiunitSess1{5})
    if iscell(MultiunitSess2{5})
    tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5}{1}};
    else
    tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5}};
    end
end

tmpSession{6} = [SessNum1,SessNum2];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Multiunit','Multiunit'};

MultiunitMultiunitSession = tmpSession;

