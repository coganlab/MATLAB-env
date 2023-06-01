function SpikeSpikeFieldSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess)
%
%   SpikeSpikeFieldSession = createSpikeSpikeField_Session(SpikeSess1,SpikeSess2,FieldSess)
%
%   Inputs:
%     SpikeSess1 = Cell array. A Spike Session
%     SpikeSess2 = Cell array. A Spike Session
%     FieldSess = Cell array. A Field Session
%
%  Outputs: 
%    SpikeSpikeFieldSession = Cell array.  The corresponding Spike-Spike-Field session
%

SessNum1 = SpikeSess1{6};
SessNum2 = SpikeSess2{6};
SessNum3 = FieldSess{6};

MonkeyName = sessMonkeyName(SpikeSess1);


if SessNum1 > SessNum2
    tmp = SpikeSess1;
    SpikeSess1 = SpikeSess2;
    SpikeSess2 = tmp;
    SessNum1 = SpikeSess1{6};
    SessNum2 = SpikeSess2{6};
end

tmpSession = cell(0,0);
tmpSession(1) = intersect(intersect(SpikeSess1(1),SpikeSess2(1)),intersect(SpikeSess1(1),FieldSess(1)));
tmpSession{2} = intersect(intersect(SpikeSess1{2},SpikeSess2{2}),intersect(SpikeSess1{2},FieldSess{2}));
tmpSession{3}{1} = sessTower(SpikeSess1);
tmpSession{3}{2} = sessTower(SpikeSess2);
tmpSession{3}{3} = sessTower(FieldSess);
Contact = sessContact(SpikeSess1);
tmpSession{4}{1} = {sessElectrode(SpikeSess1),Contact(1)};
Contact = sessContact(SpikeSess2);
tmpSession{4}{2} = {sessElectrode(SpikeSess2),Contact(1)};
Contact= sessContact(FieldSess);
tmpSession{4}{3} = {sessElectrode(FieldSess),Contact(1)};

if iscell(SpikeSess1{5})
    if iscell(SpikeSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5}{1},FieldSess{5}{1}};
        elseif ~iscell(SpikeSess2{5})
            tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5}{1},FieldSess{5}};
        end
    elseif ~iscell(SpikeSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5},FieldSess{5}{1}};
        elseif ~iscell(SpikeSess2{5})
            tmpSession{5} = {SpikeSess1{5}{1},SpikeSess2{5},FieldSess{5}};
        end
    end
elseif ~iscell(SpikeSess1{5})
    if iscell(SpikeSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess1{5},SpikeSess2{5}{1},FieldSess{5}{1}};
        elseif ~iscell(SpikeSess2{5})
            tmpSession{5} = {SpikeSess1{5},SpikeSess2{5}{1},FieldSess{5}};
        end
    elseif ~iscell(SpikeSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess1{5},SpikeSess2{5},FieldSess{5}{1}};
        elseif ~iscell(SpikeSess2{5})
            tmpSession{5} = {SpikeSess1{5},SpikeSess2{5},FieldSess{5}};
        end
    end
end
    tmpSession{6} = [SessNum1,SessNum2,SessNum3];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Spike','Spike','Field'};


SpikeSpikeFieldSession = tmpSession;



