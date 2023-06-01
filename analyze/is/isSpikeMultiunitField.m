function flag = isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess)
%
%  flag = isSpikeMultiunitField(SpikeSess,MultiunitSess,FieldSess)
%
%  Minimum number of spike spike field trials is 20

MINSPIKEMULTIUNITFIELDTRIALS = 20;

MonkeyName1 = sessMonkeyName(SpikeSess);
MonkeyName2 = sessMonkeyName(FieldSess);
if strcmp(MonkeyName1,MonkeyName2)
        MonkeyName = MonkeyName1;
else
        error('Sessions must be from same Project')
end


if length(intersect(SpikeSess(1),MultiunitSess(1)))* ...
        length(intersect(SpikeSess{2},MultiunitSess{2}))* ...
        length(intersect(SpikeSess(1),FieldSess(1)))* ...
        length(intersect(SpikeSess{2},FieldSess{2}))* ...
        length(intersect(MultiunitSess(1),FieldSess(1)))* ...
        length(intersect(MultiunitSess{2},FieldSess{2}))
    tmpSession(1) = intersect(SpikeSess(1),MultiunitSess(1),FieldSess(1));
    tmpSession{2} = intersect(SpikeSess{2},MultiunitSess{2},FieldSess{2});
    tmpSession{3}(1) = sessTower(SpikeSess);
    tmpSession{3}(2) = sessTower(MultiunitSess);
    tmpSession{3}(3) = sessTower(FieldSess);
    Contact1 = sessContact(SpikeSess);
    Contact2 = sessContact(MultiunitSess);
    Contact3 = sessContact(FieldSess);
    if ~iscell(Contact1); Contact1 = {Contact1}; end
    if ~iscell(Contact2); Contact2 = {Contact2}; end
    if ~iscell(Contact3); Contact3 = {Contact3}; end
    tmpSession{4}{1} = {sessElectrode(SpikeSess),Contact1{1}};
    tmpSession{4}{2} = {sessElectrode(MultiunitSess),Contact2{1}};
    tmpSession{4}{3} = {sessElectrode(FieldSess),Contact3{1}};
    
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
    tmpSession{6} = [sessNumber(SpikeSess),sessNumber(MultiunitSess),sessNumber(FieldSess)];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Spike','Multiunit','Field'};
    
    if length(sessTrials(tmpSession,'')) > MINSPIKEMULTIUNITFIELDTRIALS;
        flag = 1;
    else
        flag = 0;
    end
else
    flag = 0;
end
