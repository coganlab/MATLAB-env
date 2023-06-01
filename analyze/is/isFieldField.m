function flag = isFieldField(FieldSess1,FieldSess2,DayTrials)
%
%  flag = isFieldField(FieldSess1,FieldSess2,DayTrials)
%

MINFIELDFIELDTRIALS = 20;

MonkeyName1 = sessMonkeyName(FieldSess1);
MonkeyName2 = sessMonkeyName(FieldSess2);
if strcmp(MonkeyName1,MonkeyName2)
        MonkeyName = MonkeyName1;
else
        error('Sessions must be from same Project')
end


if FieldSess1{6}~=FieldSess2{6}
    if length(intersect(FieldSess1(1),FieldSess2(1)))* ...
            length(intersect(FieldSess1{2},FieldSess2{2}))
        
        if nargin == 3
            tmpSession(1) = DayTrials;
        else
            tmpSession(1) = intersect(FieldSess1(1),FieldSess2(1));
        end
        tmpSession{2} = intersect(FieldSess1{2},FieldSess2{2});
        tmpSession{3}(1) = sessTower(FieldSess1);
        tmpSession{3}(2) = sessTower(FieldSess2);
        Contact1 = sessContact(FieldSess1);
        Contact2 = sessContact(FieldSess2);
        if ~iscell(Contact1); Contact1 = {Contact1}; end
        if ~iscell(Contact2); Contact2 = {Contact2}; end

        
        tmpSession{4}{1} = {sessElectrode(FieldSess1),Contact1{1}};
        tmpSession{4}{2} = {sessElectrode(FieldSess2),Contact2{1}};
        
        if  iscell(FieldSess1{5}) && iscell(FieldSess2{5})
            tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5}{1}};
        elseif iscell(FieldSess1{5}) && ~iscell(FieldSess2{5})
            tmpSession{5} = {FieldSess1{5}{1},FieldSess2{5}(1)};
        elseif ~iscell(FieldSess1{5}) && iscell(FieldSess2{5})
            tmpSession{5} = {FieldSess1{5}(1),FieldSess2{5}{1}};
        else
            tmpSession{5} = {FieldSess1{5}(1),FieldSess2{5}(1)};
        end
        tmpSession{6} = [sessNumber(FieldSess1),sessNumber(FieldSess2)];
        tmpSession{7} = MonkeyName;
        tmpSession{8} = {'Field','Field'};
        if length(sessTrials(tmpSession,'')) > MINFIELDFIELDTRIALS;
            flag = 1;
        else
            flag = 0;
        end
    else
        flag = 0;
    end
else
    flag = 0;
end

