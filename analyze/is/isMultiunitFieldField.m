function flag = isMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2)
%
%  flag = isMultiunitFieldField(MultiunitSess,FieldSess1,FieldSess2)
%
%  Minimum number of spike field trials is 20

MINMULTIUNITFIELDFIELDTRIALS = 20;

MonkeyName1 = sessMonkeyName(MultiunitSess);
MonkeyName2 = sessMonkeyName(FieldSess1);
if strcmp(MonkeyName1,MonkeyName2)
	        MonkeyName = MonkeyName1;
else
        error('Sessions must be from same Project')
end


if length(intersect(MultiunitSess(1),FieldSess1(1)))* ...
        length(intersect(MultiunitSess{2},FieldSess1{2}))* ...
        length(intersect(MultiunitSess(1),FieldSess2(1)))* ...
        length(intersect(MultiunitSess{2},FieldSess2{2}))* ...
        length(intersect(FieldSess1(1),FieldSess2(1)))* ...
        length(intersect(FieldSess1{2},FieldSess2{2}))
    tmpSession(1) = intersect(MultiunitSess(1),FieldSess1(1),FieldSess2(1));
    tmpSession{2} = intersect(MultiunitSess{2},FieldSess1{2},FieldSess2{2});
    tmpSession{3}(1) = sessTower(MultiunitSess);
    tmpSession{3}(2) = sessTower(FieldSess1);
    tmpSession{3}(3) = sessTower(FieldSess2);
    Contact1 = sessContact(MultiunitSess);
    Contact2 = sessContact(FieldSess1);
    Contact3 = sessContact(FieldSess2);
    if ~iscell(Contact1); Contact1 = {Contact1}; end
    if ~iscell(Contact2); Contact2 = {Contact2}; end
    if ~iscell(Contact3); Contact3 = {Contact3}; end
    tmpSession{4}{1} = {sessElectrode(MultiunitSess),Contact1{1}};
    tmpSession{4}{2} = {sessElectrode(FieldSess1),Contact2{1}};
    tmpSession{4}{3} = {sessElectrode(FieldSess2),Contact3{1}};
    
    if iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess1{5}{1},FieldSess2{5}};
        end
    elseif ~iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess1{5},FieldSess2{5}{1}};
        elseif ~iscell(FieldSess1{5})
            tmpSession{5} = {MultiunitSess{5},FieldSess1{5},FieldSess2{5}};
        end
    end
    tmpSession{6} = [sessNumber(MultiunitSess),sessNumber(FieldSess1),sessNumber(FieldSess2)];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Multiunit','Field','Field'};
    if length(sessTrials(tmpSession,'')) > MINMULTIUNITFIELDFIELDTRIALS;
        flag = 1;
    else
        flag = 0;
    end
else
    flag = 0;
end
