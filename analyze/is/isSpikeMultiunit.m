function flag = isSpikeMultiunit(SpikeSess,MultiunitSess,DayTrials)
%
%  [flag,ind] = isSpikeSpike(SpikeSess,MultiunitSess,DayTrials)
%

SN1 = sessNumber(SpikeSess);
SN2 = sessNumber(MultiunitSess);
MINSPIKEMULTIUNITTRIALS = 20;

MonkeyName1 = sessMonkeyName(SpikeSess);
MonkeyName2 = sessMonkeyName(MultiunitSess);
if strcmp(MonkeyName1,MonkeyName2)
        MonkeyName = MonkeyName1;
else
        error('Sessions must be from same Project')
end


if SN1 ~= SN2
    if(length(intersect(SpikeSess(1),MultiunitSess(1)))* ... % Check sessions are on the same day
            length(intersect(SpikeSess{2},MultiunitSess{2})))%  Check there are overlapping recordings
        if nargin == 3
            tmpSession(1) = DayTrials;
        else
            tmpSession(1) = intersect(SpikeSess(1),MultiunitSess(1));
        end
        tmpSession{2} = intersect(SpikeSess{2},MultiunitSess{2});
    tmpSession{3}{1} = sessTower(SpikeSess);
    tmpSession{3}{2} = sessTower(MultiunitSess);
    Contact1 = sessContact(SpikeSess);
    Contact2 = sessContact(MultiunitSess);
    tmpSession{4}{1} = {sessElectrode(SpikeSess),Contact1(1)};
    tmpSession{4}{2} = {sessElectrode(MultiunitSess),Contact2(1)};

        tmpSession{5} = [SpikeSess{5},MultiunitSess{5}];
    tmpSession{6} = [sessNumber(SpikeSess),sessNumber(MultiunitSess)];
    tmpSession{7} = MonkeyName;
    tmpSession{8} = {'Spike','Multiunit'};

        if length(sessTrials(tmpSession,'')) > MINSPIKEMULTIUNITTRIALS;
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


