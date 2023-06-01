function flag = isFieldFieldField(FieldSess1,FieldSess2,FieldSess3)
%
%  flag = isFieldFieldField(FieldSess1,FieldSess2,FieldSess3)
%
%  Minimum number of spike field trials is 20

MINFIELDFIELDFIELDTRIALS = 20;

MonkeyName1 = sessMonkeyName(FieldSess1);
MonkeyName2 = sessMonkeyName(FieldSess2);
if strcmp(MonkeyName1,MonkeyName2)
    MonkeyName = MonkeyName1;
else
    error('Sessions must be from same Project')
end


if length(intersect(FieldSess1(1),FieldSess2(1)))* ...
        length(intersect(FieldSess1{2},FieldSess2{2}))* ...
        length(intersect(FieldSess1(1),FieldSess3(1)))* ...
        length(intersect(FieldSess1{2},FieldSess3{2}))* ...
        length(intersect(FieldSess2(1),FieldSess3(1)))* ...
        length(intersect(FieldSess2{2},FieldSess3{2}))
    tmpSession(1) = intersect(FieldSess1(1),FieldSess2(1),FieldSess3(1));
    tmpSession{2} = intersect(FieldSess1{2},FieldSess2{2},FieldSess3{2});
    tmpSession{3}(1) = sessTower(FieldSess1);
    tmpSession{3}(2) = sessTower(FieldSess2);
    tmpSession{3}(3) = sessTower(FieldSess3);
    Contact1 = sessContact(FieldSess1);
    Contact2 = sessContact(FieldSess2);
    Contact3 = sessContact(FieldSess3);
    if ~iscell(Contact1); Contact1 = {Contact1}; end
    if ~iscell(Contact2); Contact2 = {Contact2}; end
    if ~iscell(Contact3); Contact3 = {Contact3}; end
    
    tmpSession{4}{1} = {sessElectrode(FieldSess1),Contact1{1}};
    tmpSession{4}{2} = {sessElectrode(FieldSess2),Contact2{1}};
    tmpSession{4}{3} = {sessElectrode(FieldSess3),Contact3{1}};
    if iscell(FieldSess2{5})
        if iscell(FieldSess2{5})
            if iscell(FieldSess3{5})
                tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5}{1},FieldSess3{5}{1}};
            elseif ~iscell(FieldSess2{5})
                tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5}{1},FieldSess3{5}};
            end
        elseif ~iscell(FieldSess2{5})
            if iscell(FieldSess3{5})
                tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5},FieldSess3{5}{1}};
            elseif ~iscell(FieldSess2{5})
                tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5},FieldSess3{5}};
            end
        end
    elseif ~iscell(FieldSess1{5})
        if iscell(FieldSess2{5})
            if iscell(FieldSess3{5})
                tmpSession{5} = {FieldSess1{5},FieldSess2{5}{1},FieldSess3{5}{1}};
            elseif ~iscell(FieldSess2{5})
                tmpSession{5} = {FieldSess1{5},FieldSess2{5}{1},FieldSess3{5}};
            end
        elseif ~iscell(FieldSess2{5})
            if iscell(FieldSess3{5})
                tmpSession{5} = {FieldSess1{5},FieldSess2{5},FieldSess3{5}{1}};
            elseif ~iscell(FieldSess2{5})
                tmpSession{5} = {FieldSess1{5},FieldSess2{5},FieldSess3{5}};
            end
        end
    end
    tmpSession{6} = [sessNumber(FieldSess1),sessNumber(FieldSess2),sessNumber(FieldSess3)];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Field','Field','Field'};
    
    if length(sessTrials(tmpSession,'')) > MINFIELDFIELDFIELDTRIALS;
        flag = 1;
    else
        flag = 0;
    end
else
    flag = 0;
end
