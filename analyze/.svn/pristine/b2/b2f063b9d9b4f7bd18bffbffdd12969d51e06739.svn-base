function flag = isSpikeField(SpikeSess,FieldSess)
%
%  flag = isSpikeField(SpikeSess,FieldSess,DayTrials)
%
%  Minimum number of spike field trials is 20

MINSPIKEFIELDTRIALS = 20;

MonkeyName1 = sessMonkeyName(SpikeSess);
MonkeyName2 = sessMonkeyName(FieldSess);
if strcmp(MonkeyName1,MonkeyName2)
        MonkeyName = MonkeyName1;
else
        error('Sessions must be from same Project')
end

if length(intersect(SpikeSess(1),FieldSess(1)))* ...
        length(intersect(SpikeSess{2},FieldSess{2}))
    if nargin == 3
      tmpSession(1) = DayTrials;
    else
      tmpSession(1) = intersect(SpikeSess(1),FieldSess(1));
    end
    tmpSession{2} = intersect(SpikeSess{2},FieldSess{2});
    tmpSession{3}(1) = sessTower(SpikeSess);
    tmpSession{3}(2) = sessTower(FieldSess);
    Contact = sessContact(SpikeSess);
    tmpSession{4}{1} = {sessElectrode(SpikeSess),Contact(1)};
    Contact = sessContact(FieldSess);
    tmpSession{4}{2} = {sessElectrode(FieldSess),Contact(1)};

    if  iscell(FieldSess{5})
        tmpSession{5} = {SpikeSess{5}(1),FieldSess{5}{1}};
    elseif ~iscell(FieldSess{5})
        tmpSession{5} = {SpikeSess{5}(1),FieldSess{5}(1)};
    end
    tmpSession{6} = [sessNumber(SpikeSess),sessNumber(FieldSess)];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Spike','Field'};
    
    if length(sessTrials(tmpSession,'')) > MINSPIKEFIELDTRIALS;
        flag = 1;
    else
        flag = 0;
    end
else
    flag = 0;
end
