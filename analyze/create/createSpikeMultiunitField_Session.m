function SpikeMultiunitFieldSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess)
%
%   SpikeMultiunitFieldSession = createSpikeMultiunitField_Session(SpikeSess,MultiunitSess,FieldSess)
%
%   Inputs:
%     SpikeSess = Cell array. A Multiunit Session
%     MultiunitSess = Cell array. A Multiunit Session
%     FieldSess = Cell array. A Field Session
%
%  Outputs: 
%    SpikeMultiunitFieldSession = Cell array.  The corresponding Multiunit-Multiunit-Field session
%

SessNum1 = SpikeSess{6};
SessNum2 = MultiunitSess{6};
SessNum3 = FieldSess{6};

MonkeyName = sessMonkeyName(SpikeSess);



tmpSession = cell(0,0);
tmpSession(1) = intersect(intersect(SpikeSess(1),MultiunitSess(1)),intersect(SpikeSess(1),FieldSess(1)));
tmpSession{2} = intersect(intersect(SpikeSess{2},MultiunitSess{2}),intersect(SpikeSess{2},FieldSess{2}));
tmpSession{3}{1} = sessTower(SpikeSess);
tmpSession{3}{2} = sessTower(MultiunitSess);
tmpSession{3}{3} = sessTower(FieldSess);
Contact = sessContact(SpikeSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{1} = {sessElectrode(SpikeSess),Contact{1}};
Contact = sessContact(MultiunitSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{2} = {sessElectrode(MultiunitSess),Contact{1}};
Contact= sessContact(FieldSess);
if ~iscell(Contact); Contact = {Contact}; end
tmpSession{4}{3} = {sessElectrode(FieldSess),Contact{1}};

if iscell(SpikeSess{5})
    if iscell(MultiunitSess{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess{5}{1},MultiunitSess{5}{1},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess{5})
            tmpSession{5} = {SpikeSess{5}{1},MultiunitSess{5}{1},FieldSess{5}};
        end
    elseif ~iscell(MultiunitSess{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess{5}{1},MultiunitSess{5},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess{5})
            tmpSession{5} = {SpikeSess{5}{1},MultiunitSess{5},FieldSess{5}};
        end
    end
elseif ~iscell(SpikeSess{5})
    if iscell(MultiunitSess{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess{5},MultiunitSess{5}{1},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess{5})
            tmpSession{5} = {SpikeSess{5},MultiunitSess{5}{1},FieldSess{5}};
        end
    elseif ~iscell(MultiunitSess{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {SpikeSess{5},MultiunitSess{5},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess{5})
            tmpSession{5} = {SpikeSess{5},MultiunitSess{5},FieldSess{5}};
        end
    end
end
tmpSession{6} = [SessNum1,SessNum2,SessNum3];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Spike','Multiunit','Field'};


SpikeMultiunitFieldSession = tmpSession;



