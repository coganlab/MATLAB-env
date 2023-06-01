function flag = isMultiunitField(MultiunitSess,FieldSess)
%
%  flag = isMultiunitField(MultiunitSess,FieldSess)
%
%  Minimum number of multiunit field trials is 20

MINMULTIUNITFIELDTRIALS = 20;

MonkeyName1 = sessMonkeyName(MultiunitSess);
MonkeyName2 = sessMonkeyName(FieldSess);
if strcmp(MonkeyName1,MonkeyName2)
    MonkeyName = MonkeyName1;
else
    error('Sessions must be from same Project')
end

if length(intersect(MultiunitSess(1),FieldSess(1)))* ...
        length(intersect(MultiunitSess{2},FieldSess{2}))
    flag = 1;
    tmpSession(1) = intersect(MultiunitSess(1),FieldSess(1));
    tmpSession{2} = intersect(MultiunitSess{2},FieldSess{2});
    tmpSession{3}(1) = sessTower(MultiunitSess);
    tmpSession{3}(2) = sessTower(FieldSess);
    Contact1 = sessContact(MultiunitSess);
    if ~iscell(Contact1); Contact1 = {Contact1}; end
    Contact2 = sessContact(FieldSess);
    if ~iscell(Contact2); Contact2 = {Contact2}; end
    tmpSession{4}{1} = {sessElectrode(MultiunitSess),Contact1{1}};
    tmpSession{4}{2} = {sessElectrode(FieldSess),Contact2{1}};
    if  iscell(FieldSess{5})
        tmpSession{5} = {MultiunitSess{5}(1),FieldSess{5}{1}};
    elseif ~iscell(FieldSess{5})
        tmpSession{5} = {MultiunitSess{5}(1),FieldSess{5}(1)};
    end
    tmpSession{6} = [sessNumber(MultiunitSess),sessNumber(FieldSess)];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Multiunit','Field'};
%     if length(sessTrials(tmpSession)) > MINMULTIUNITFIELDTRIALS;
%         flag = 1;
%     else
%         flag = 0;
%     end
else
    flag = 0;
end
