function flag = isSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess)
%
%  flag = isSpikeSpikeField(SpikeSess1,SpikeSess2,FieldSess)
%
%  Minimum number of spike spike field trials is 20

MINSPIKESPIKEFIELDTRIALS = 20;
MonkeyDir1 = sessMonkeyDir(SpikeSess1);
MonkeyDir2 = sessMonkeyDir(FieldSess);
if strcmp(MonkeyDir1,MonkeyDir2)
    MonkeyDir = MonkeyDir1;
else
    error('Sessions must be from same Project')
end


if length(intersect(SpikeSess1(1),SpikeSess2(1)))* ...
        length(intersect(SpikeSess1{2},SpikeSess2{2}))* ...
        length(intersect(SpikeSess1(1),FieldSess(1)))* ...
        length(intersect(SpikeSess1{2},FieldSess{2}))* ...
        length(intersect(SpikeSess2(1),FieldSess(1)))* ...
        length(intersect(SpikeSess2{2},FieldSess{2}))
    ind1 = intersect(SpikeSess1(1),SpikeSess2(1));
    ind2 = intersect(SpikeSess1(1),FieldSess(1));
    tmpSession(1) = intersect(ind1,ind2);
    ind1 = intersect(SpikeSess1{2},SpikeSess2{2});
    ind2 = intersect(SpikeSess1{2},FieldSess{2});
    tmpSession{2} = intersect(ind1,ind2);
    tmpSession{3}(1) = sessTower(SpikeSess1);
    tmpSession{3}(2) = sessTower(SpikeSess2);
    tmpSession{3}(3) = sessTower(FieldSess);
    Contact1 = sessContact(SpikeSess1);
    Contact2 = sessContact(SpikeSess2);
    Contact3 = sessContact(FieldSess);
    tmpSession{4}{1} = {sessElectrode(SpikeSess1),Contact1(1)};
    tmpSession{4}{2} = {sessElectrode(SpikeSess2),Contact2(1)};
    tmpSession{4}{3} = {sessElectrode(FieldSess),Contact3(1)};

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
    tmpSession{6} = [sessNumber(SpikeSess1),sessNumber(SpikeSess2),sessNumber(FieldSess)];
    tmpSession{7} = MonkeyDir;
    tmpSession{8} = {'Spike','Spike','Field'};

    if length(sessTrials(tmpSession,'')) > MINSPIKESPIKEFIELDTRIALS;
        flag = 1;
    else
        flag = 0;
    end
else
    flag = 0;
end
