function tmpSession = createFieldField_Session(FieldSess1,FieldSess2)
%
%   tmpSession = createFieldField_Session(FieldSess1,FieldSess2)
%

SessNum1 = FieldSess1{6};
SessNum2 = FieldSess2{6};
MonkeyDir1 = sessMonkeyDir(FieldSess1);
MonkeyDir2 = sessMonkeyDir(FieldSess2);
if strcmp(MonkeyDir1,MonkeyDir2)
  MonkeyDir = MonkeyDir1;
else
  error('Sessions must be from same MONKEYDIR');
end

if SessNum1 > SessNum2
    tmp = FieldSess1;
    FieldSess1 = FieldSess2;
    FieldSess2 = tmp;
    SessNum1 = FieldSess1{6};
    SessNum2 = FieldSess2{6};
end

tmpSession = cell(0,0);
tmpSession(1) = intersect(FieldSess1(1),FieldSess1(1));
tmpSession{2} = intersect(FieldSess2{2},FieldSess2{2});
tmpSession{3}{1} = sessTower(FieldSess1);
tmpSession{3}{2} = sessTower(FieldSess2);
Contact = sessContact(FieldSess1);
if(iscell(Contact))
    Contact = Contact{1};
end
tmpSession{4}{1} = {sessElectrode(FieldSess1),Contact};
Contact= sessContact(FieldSess2);
tmpSession{4}{2} = {sessElectrode(FieldSess2),Contact};
if iscell(FieldSess1{5}) && iscell(FieldSess2{5})
    tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5}{1}};
elseif iscell(FieldSess1{5}) && ~iscell(FieldSess2{5})
    tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5}};
elseif ~iscell(FieldSess1{5}) && iscell(FieldSess2{5})
    tmpSession{5} = {FieldSess1{5},FieldSess2{5}{1}};
elseif ~iscell(FieldSess1{5}) && ~iscell(FieldSess2{5})
    tmpSession{5} = {FieldSess1{5},FieldSess2{5}};
end
tmpSession{6} = [SessNum1,SessNum2];
tmpSession{7} = MonkeyDir;
tmpSession{8} = {'Field','Field'};

%NumTrials = [];
%CurrentSession = tmpSession;
%if nargin ==3 
%  CurrentSession{1} = DayTrials;
%end
%Trials = sessTrials(CurrentSession);
%for iTask = 1:length(TASKLIST)
%    NumTrials.(TASKLIST{iTask}) = length(TaskTrials(Trials,TASKLIST{iTask}));
%end
%tmpSession{7} = NumTrials;
%NumTrialsConds = [];
%for iTask = 1:length(TASKLIST)
%    myTrials = TaskTrials(Trials,TASKLIST{iTask});
%    if length(myTrials)
%        Conds = trials2conds(myTrials);
%    else Conds = zeros(5,5,15); end
%    NumTrialsConds.(TASKLIST{iTask}) = Conds;
%end
%tmpSession{8} = NumTrialsConds;
