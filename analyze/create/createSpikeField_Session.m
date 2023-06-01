function SpikeFieldSession = createSpikeField_Session(SpikeSess,FieldSess)
%
%   SpikeFieldSession = createSpikeField_Session(SpikeSess,FieldSess)
%
%   Inputs:
%     SpikeSess = Cell array. A Spike Session
%     FieldSess = Cell array. A Field Session
%
%  Outputs: 
%    SpikeFieldSession = Cell array.  The corresponding Spike-Field session
%

SessNum1 = SpikeSess{6};
SessNum2 = FieldSess{6};

MonkeyName1 = sessMonkeyName(SpikeSess);
MonkeyName2 = sessMonkeyName(FieldSess);
if strcmp(MonkeyName1,MonkeyName2)
  MonkeyName = MonkeyName1;
else
  error('Sessions must be from the same Monkey');
end


tmpSession = cell(0,0);
tmpSession(1) = intersect(SpikeSess(1),FieldSess(1));
tmpSession{2} = intersect(SpikeSess{2},FieldSess{2});
tmpSession{3}{1} = sessTower(SpikeSess);
tmpSession{3}{2} = sessTower(FieldSess);
Contact = sessContact(SpikeSess);
tmpSession{4}{1} = {sessElectrode(SpikeSess),Contact(1)};
Contact = sessContact(FieldSess);
tmpSession{4}{2} = {sessElectrode(FieldSess),Contact(1)};
if iscell(SpikeSess{5})
    if iscell(FieldSess{5})
        tmpSession{5} = {SpikeSess{5}{1},FieldSess{5}{1}};
    else
        tmpSession{5} = {SpikeSess{5}{1},FieldSess{5}};
    end
elseif ~iscell(SpikeSess{5})
    if iscell(FieldSess{5})
        tmpSession{5} = {SpikeSess{5},FieldSess{5}{1}};
    else
        tmpSession{5} = {SpikeSess{5},FieldSess{5}};
    end
end
tmpSession{6} = [SessNum1,SessNum2];
tmpSession{7} = MonkeyName;
tmpSession{8} = {'Spike','Field'};

SpikeFieldSession = tmpSession;

%NumTrials = [];
%CurrentSession = tmpSession;
%if nargin ==3
%  CurrentSession{1} = DayTrials;
%end
%Trials = sessTrials(CurrentSession);
%for iTask = 1:length(TASKLIST)
%    NumTrials.(TASKLIST{iTask}) = ...
%        length(TaskTrials(Trials,TASKLIST{iTask}));
%end
%tmpSession{7} = NumTrials;
%NumTrialsConds = [];
%for iTask = 1:length(TASKLIST)
%    myTrials = TaskTrials(Trials,TASKLIST{iTask});
%    if ~isempty(myTrials)
%        Conds = trials2conds(myTrials);
%    else Conds = zeros(5,5,15); end
%    NumTrialsConds.(TASKLIST{iTask}) = Conds;
%end
%tmpSession{8} = NumTrialsConds;
