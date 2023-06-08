function flag = isSpikeFieldField(SpikeSess,FieldSess1,FieldSess2)
%
%  flag = isSpikeFieldField(SpikeSess,FieldSess1,FieldSess2)
%
%  Minimum number of spike field trials is 20

MINSPIKEFIELDFIELDTRIALS = 20;

MonkeyName1 = sessMonkeyName(SpikeSess);
MonkeyName2 = sessMonkeyName(FieldSess1);
if strcmp(MonkeyName1,MonkeyName2)
        MonkeyName = MonkeyName1;
else
        error('Sessions must be from same Project')
end

if length(intersect(SpikeSess(1),FieldSess1(1)))* ...
        length(intersect(SpikeSess{2},FieldSess1{2}))* ...
        length(intersect(SpikeSess(1),FieldSess2(1)))* ...
        length(intersect(SpikeSess{2},FieldSess2{2}))* ...
        length(intersect(FieldSess1(1),FieldSess2(1)))* ...
        length(intersect(FieldSess1{2},FieldSess2{2}))
    ind1 = intersect(SpikeSess(1),FieldSess1(1));
    ind2 = intersect(SpikeSess(1),FieldSess2(1));
    tmpSession(1) = intersect(ind1,ind2);
    ind1 = intersect(SpikeSess{2},FieldSess1{2});
    ind2 = intersect(SpikeSess{2},FieldSess2{2});
    tmpSession{2} = intersect(ind1,ind2);
    tmpSession{3}(1) = sessTower(SpikeSess);
    tmpSession{3}(2) = sessTower(FieldSess1);
    tmpSession{3}(3) = sessTower(FieldSess2);
    Contact1 = sessContact(SpikeSess);
    Contact2 = sessContact(FieldSess1);
    Contact3 = sessContact(FieldSess2);
    tmpSession{4}{1} = {sessElectrode(SpikeSess),Contact1(1)};
    tmpSession{4}{2} = {sessElectrode(FieldSess1),Contact2(1)};
    tmpSession{4}{3} = {sessElectrode(FieldSess2),Contact3(1)};

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
    tmpSession{6} = [sessNumber(SpikeSess),sessNumber(FieldSess1),sessNumber(FieldSess2)];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Spike','Field','Field'};

    if length(sessTrials(tmpSession,'')) > MINSPIKEFIELDFIELDTRIALS;
        flag = 1;
    else
        flag = 0;
    end
else
    flag = 0;
end
