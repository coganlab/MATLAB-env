function SpikeSpikeSession = createSpikeSpike_Session(SpikeSess1,SpikeSess2)
%
%   SpikeSpikeSession = createSpikeSpike_Session(SpikeSess,SpikeSess)
%

SessNum1 = SpikeSess1{6};
SessNum2 = SpikeSess2{6};

MonkeyName1 = sessMonkeyName(SpikeSess1);
MonkeyName2 = sessMonkeyName(SpikeSess2);
if strcmp(MonkeyName1,MonkeyName2)
  MonkeyName = MonkeyName1;
else
  error('Sessions must be form the same Monkey Name');
end

if SessNum1 > SessNum2
    tmp = SpikeSess1;
    SpikeSess1 = SpikeSess2;
    SpikeSess2 = tmp;
    SessNum1 = SpikeSess1{6};
    SessNum2 = SpikeSess2{6};
end

tmpSession = cell(0,0);
tmpSession(1) = intersect(SpikeSess1(1),SpikeSess2(1));
tmpSession{2} = intersect(SpikeSess1{2},SpikeSess2{2});
tmpSession{3}{1} = sessTower(SpikeSess1);
tmpSession{3}{2} = sessTower(SpikeSess2);
Contact = sessContact(SpikeSess1);
tmpSession{4}{1} = {sessElectrode(SpikeSess1),Contact(1)};
Contact = sessContact(SpikeSess2);
tmpSession{4}{2} = {sessElectrode(SpikeSess2),Contact(1)};
if iscell(SpikeSess1{5})
    if iscell(SpikeSess2{5})
    tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5}{1}};
    else
    tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5}};
    end
elseif ~iscell(SpikeSess1{5})
    if iscell(SpikeSess2{5})
    tmpSession{5} = {SpikeSess1{5},SpikeSess2{5}{1}};
    else
    tmpSession{5} = {SpikeSess1{5},SpikeSess2{5}};
    end
end

tmpSession{6} = [SessNum1,SessNum2];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Spike','Spike'};

SpikeSpikeSession = tmpSession;

