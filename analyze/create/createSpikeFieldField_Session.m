function SpikeFieldFieldSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2)
%
%   SpikeFieldFieldSession = createSpikeFieldField_Session(SpikeSess,FieldSess1,FieldSess2)
%
%   Inputs:
%     SpikeSess = Cell array. A Spike Session
%     FieldSess1 = Cell array. A Field Session
%     FieldSess2 = Cell array. A Field Session
%
%  Outputs: 
%    SpikeFieldFieldSession = Cell array.  The corresponding Spike-Field-Field session
%

SessNum1 = sessNumber(SpikeSess);
SessNum2 = sessNumber(FieldSess1);
SessNum3 = sessNumber(FieldSess2);

ProjectDir = sessProjectDir(SpikeSess);

% if SessNum2 > SessNum3
%     tmp = FieldSess1;
%     FieldSess1 = FieldSess2;
%     FieldSess2 = tmp;
%     SessNum2 = sessNumber(FieldSess1);
%     SessNum3 = sessNumber(FieldSess2);
% end

tmpSession = cell(0,0);
tmpSession(1) = intersect(intersect(SpikeSess(1),FieldSess1(1)),intersect(SpikeSess(1),FieldSess2(1)));
tmpSession{2} = intersect(intersect(SpikeSess{2},FieldSess1{2}),intersect(SpikeSess{2},FieldSess2{2}));
tmpSession{3}{1} = sessTower(SpikeSess);
tmpSession{3}{2} = sessTower(FieldSess1);
tmpSession{3}{3} = sessTower(FieldSess2);
Contact = sessContact(SpikeSess);
tmpSession{4}{1} = {sessElectrode(SpikeSess),Contact(1)};
Contact = sessContact(FieldSess1);
tmpSession{4}{2} = {sessElectrode(FieldSess1),Contact(1)};
Contact = sessContact(FieldSess2);
tmpSession{4}{3} = {sessElectrode(FieldSess2),Contact(1)};

if iscell(SpikeSess{5})
    if iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {SpikeSess{5}{1},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {SpikeSess{5}{1},FieldSess1{5}{1},FieldSess2{5}};
        end
    elseif ~iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {SpikeSess{5}{1},FieldSess1{5},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {SpikeSess{5}{1},FieldSess1{5},FieldSess2{5}};
        end
    end
elseif ~iscell(SpikeSess{5})
    if iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {SpikeSess{5},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {SpikeSess{5},FieldSess1{5}{1},FieldSess2{5}};
        end
    elseif ~iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {SpikeSess{5},FieldSess1{5},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {SpikeSess{5},FieldSess1{5},FieldSess2{5}};
        end
    end
end
tmpSession{6} = [SessNum1,SessNum2,SessNum3];
tmpSession{7} = ProjectDir;
tmpSession{8} = {'Spike','Field','Field'};

SpikeFieldFieldSession = tmpSession;



