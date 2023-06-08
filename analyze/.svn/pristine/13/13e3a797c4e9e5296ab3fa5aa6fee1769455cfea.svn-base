function flag = isMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess)
%
%  flag = isMultiunitMultiunitField(MultiunitSess1,MultiunitSess2,FieldSess)
%
%  Minimum number of spike spike field trials is 20

MINMULTIUNITMULTIUNITFIELDTRIALS = 20;

MonkeyName1 = sessMonkeyName(MultiunitSess1);
MonkeyName2 = sessMonkeyName(MultiunitSess2);
if strcmp(MonkeyName1,MonkeyName2)
	        MonkeyName = MonkeyName1;
else
        error('Sessions must be from same Project')
end

if length(intersect(MultiunitSess1(1),MultiunitSess2(1)))* ...
        length(intersect(MultiunitSess1{2},MultiunitSess2{2}))* ...
        length(intersect(MultiunitSess1(1),FieldSess(1)))* ...
        length(intersect(MultiunitSess1{2},FieldSess{2}))* ...
        length(intersect(MultiunitSess2(1),FieldSess(1)))* ...
        length(intersect(MultiunitSess2{2},FieldSess{2}))
    tmpSession(1) = intersect(MultiunitSess1(1),MultiunitSess2(1),FieldSess(1));
    tmpSession{2} = intersect(MultiunitSess1{2},MultiunitSess2{2},FieldSess{2});
    tmpSession{3}(1) = sessTower(MultiunitSess1);
    tmpSession{3}(2) = sessTower(MultiunitSess2);
    tmpSession{3}(3) = sessTower(FieldSess);
    tmpSession{4}{1} = {sessElectrode(MultiunitSess1),sessContact(MultiunitSess1)};
    tmpSession{4}{2} = {sessElectrode(MultiunitSess2),sessContact(MultiunitSess2)};
    tmpSession{4}{3} = {sessElectrode(FieldSess),sessContact(FieldSess)};

    if iscell(MultiunitSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5}{1},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess2{5})
            tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5}{1},FieldSess{5}};
        end
    elseif ~iscell(MultiunitSess2{5})
        if iscell(FieldSess{5})
            tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5},FieldSess{5}{1}};
        elseif ~iscell(MultiunitSess2{5})
            tmpSession{5} = {MultiunitSess1{5},MultiunitSess2{5},FieldSess{5}};
        end
    end
    tmpSession{6} = [sessNumber(MultiunitSess1),sessNumber(MultiunitSess2),sessNumber(FieldSess)];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Multiunit','Multiunit','Field'};

    if length(sessTrials(tmpSession,'')) > MINMULTIUNITMULTIUNITFIELDTRIALS;
        flag = 1;
    else
        flag = 0;
    end
else
    flag = 0;
end
