function SpikeSpikeFieldFieldSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2)
%
%   SpikeSpikeFieldFieldSession = createSpikeSpikeFieldField_Session(SpikeSess1,SpikeSess2,FieldSess1,FieldSess2)
%
%   Inputs:
%     SpikeSess1 = Cell array. A Spike Session
%     SpikeSess2 = Cell array. A Spike Session
%     FieldSess1 = Cell array. A Field Session
%     FieldSess2 = Cell array. A Field Session
%
%  Outputs: 
%    SpikeSpikeFieldFieldSession = Cell array.  The corresponding Spike-Spike-Field session
%

SessNum1 = SpikeSess1{6};
SessNum2 = SpikeSess2{6};
SessNum3 = FieldSess1{6};
SessNum4 = FieldSess2{6};

MonkeyName = sessMonkeyName(SpikeSess1);


if SessNum1 > SessNum2
    tmp = SpikeSess1;
    SpikeSess1 = SpikeSess2;
    SpikeSess2 = tmp;
    SessNum1 = SpikeSess1{6};
    SessNum2 = SpikeSess2{6};
end

if SessNum3 > SessNum4
    tmp = FieldSess1;
    FieldSess1 = FieldSess2;
    FieldSess2 = tmp;
    SessNum3 = FieldSess1{6};
    SessNum4 = FieldSess2{6};
end

tmpSession = cell(0,0);
tmpSession(1) = intersect(intersect(SpikeSess1(1),SpikeSess2(1)),intersect(FieldSess1(1),FieldSess2(1)));
tmpSession{2} = intersect(intersect(SpikeSess1{2},SpikeSess2{2}),intersect(FieldSess1{2},FieldSess2{2}));
tmpSession{3}{1} = sessTower(SpikeSess1);
tmpSession{3}{2} = sessTower(SpikeSess2);
tmpSession{3}{3} = sessTower(FieldSess1);
tmpSession{3}{4} = sessTower(FieldSess2);
Contact = sessContact(SpikeSess1);
tmpSession{4}{1} = {sessElectrode(SpikeSess1),Contact(1)};
Contact = sessContact(SpikeSess2);
tmpSession{4}{2} = {sessElectrode(SpikeSess2),Contact(1)};
Contact= sessContact(FieldSess1);
tmpSession{4}{3} = {sessElectrode(FieldSess1),Contact(1)};
Contact= sessContact(FieldSess2);
tmpSession{4}{4} = {sessElectrode(FieldSess2),Contact(1)};

if iscell(SpikeSess1{5})
    if iscell(SpikeSess2{5})
        if iscell(FieldSess1{5})
            tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5}{1},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(SpikeSess2{5})
            tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5}{1},FieldSess1{5}{1},FieldSess2{5}{1}};
        end
    elseif ~iscell(SpikeSess2{5})
        if iscell(FieldSess1{5})
            tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(SpikeSess2{5})
            tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5},FieldSess1{5},FieldSess2{5}};
        end
    end
elseif ~iscell(SpikeSess1{5})
    if iscell(SpikeSess2{5})
        if iscell(FieldSess1{5})
            tmpSession{5} = {SpikeSess1{5},SpikeSess2{5}{1},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(SpikeSess2{5})
            tmpSession{5} = {SpikeSess1{5},SpikeSess2{5}{1},FieldSess1{5},FieldSess2{5}};
        end
    elseif ~iscell(SpikeSess2{5})
        if iscell(FieldSess1{5})
            tmpSession{5} = {SpikeSess1{5},SpikeSess2{5},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(SpikeSess2{5})
            tmpSession{5} = {SpikeSess1{5},SpikeSess2{5},FieldSess1{5},FieldSess2{5}};
        end
    end
end
    tmpSession{6} = [SessNum1,SessNum2,SessNum3,SessNum4];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Spike','Spike','Field','Field'};


SpikeSpikeFieldFieldSession = tmpSession;
end



