function flag = isMultiunitMultiunit(MultiunitSess1,MultiunitSess2,DayTrials)
%
%  [flag,ind] = isSpikeSpike(SpikeSess1,SpikeSess2,DayTrials)
%

SN1 = sessNumber(MultiunitSess1);
SN2 = sessNumber(MultiunitSess2);
MINMULTIUNITMULTIUNITTRIALS = 20;
MonkeyName1 = sessMonkeyName(MultiunitSess1);
MonkeyName2 = sessMonkeyName(MultiunitSess2);
if strcmp(MonkeyName1,MonkeyName2)
    MonkeyName = MonkeyName1;
else
    error('Sessions must be from same Project')
end


if SN1 ~= SN2
    if(length(intersect(MultiunitSess1(1),MultiunitSess2(1)))* ... % Check sessions are on the same day
            length(intersect(MultiunitSess1{2},MultiunitSess2{2})))%  Check there are overlapping recordings
        if nargin == 3
            tmpSession(1) = DayTrials;
        else
            tmpSession(1) = intersect(MultiunitSess1(1),MultiunitSess2(1));
        end
        tmpSession{2} = intersect(MultiunitSess1{2},MultiunitSess2{2});
        tmpSession{3}(1) = sessTower(MultiunitSess1);
        tmpSession{3}(2) = sessTower(MultiunitSess2);
        Contact1 = sessContact(MultiunitSess1);
        if ~iscell(Contact1); Contact1 = {Contact1}; end
        Contact2 = sessContact(MultiunitSess2);
        if ~iscell(Contact2); Contact2 = {Contact2}; end
        tmpSession{4}{1} = {sessElectrode(MultiunitSess1),Contact1{1}};
        tmpSession{4}{2} = {sessElectrode(MultiunitSess2),Contact2{1}};
        tmpSession{5} = [MultiunitSess1{5},MultiunitSess2{5}];
        tmpSession{6} = [sessNumber(MultiunitSess1),sessNumber(MultiunitSess2)];
        tmpSession{7} = MonkeyName;
        tmpSession{8} = {'Multiunit','Multiunit'};
        
        if length(sessTrials(tmpSession,''))>MINMULTIUNITMULTIUNITTRIALS;
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


