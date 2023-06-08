function tmpSession = createSpikeMultiunit_Session(SpikeSess,MultiunitSess)
%
%   tmpSession = createMultiunitMultiunit_Session(MultiunitSess,MultiunitSess)
%

SessNum1 = SpikeSess{6};
SessNum2 = MultiunitSess{6};

MonkeyName1 = sessMonkeyName(SpikeSess);
MonkeyName2 = sessMonkeyName(MultiunitSess);
if strcmp(MonkeyName1,MonkeyName2)
  MonkeyName = MonkeyName1;
else
    error('Sessions must be from same MONKEYNAME');
end


tmpSession = cell(0,0);
tmpSession(1) = intersect(SpikeSess(1),MultiunitSess(1));
tmpSession{2} = intersect(SpikeSess{2},MultiunitSess{2});
tmpSession{3}{1} = sessTower(SpikeSess);
tmpSession{3}{2} = sessTower(MultiunitSess);
Contact = sessContact(SpikeSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{1} = {sessElectrode(SpikeSess),Contact{1}};
Contact= sessContact(MultiunitSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{2} = {sessElectrode(MultiunitSess),Contact{1}};

if iscell(SpikeSess{5})
    if iscell(MultiunitSess{5})
        tmpSession{5} = {SpikeSess{5}{1},MultiunitSess{5}{1}};
    else
        tmpSession{5} = {SpikeSess{5}{1},MultiunitSess{5}};
    end
elseif ~iscell(SpikeSess{5})
    if iscell(MultiunitSess{5})
        tmpSession{5} = {SpikeSess{5},MultiunitSess{5}{1}};
    else
        tmpSession{5} = {SpikeSess{5},MultiunitSess{5}};
    end
end
tmpSession{6} = [SessNum1,SessNum2];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Spike','Multiunit'};



