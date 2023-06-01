function flag = isSpikeSpike(SpikeSess1,SpikeSess2,DayTrials)
%
%  [flag,ind] = isSpikeSpike(SpikeSess1,SpikeSess2,DayTrials)
%

SN1 = sessNumber(SpikeSess1);
SN2 = sessNumber(SpikeSess2);
MINSPIKESPIKETRIALS = 10;

MonkeyName1 = sessMonkeyName(SpikeSess1);
MonkeyName2 = sessMonkeyName(SpikeSess2);
if strcmp(MonkeyName1,MonkeyName2)
        MonkeyName = MonkeyName1;
else
        error('Sessions must be from same Project')
end


if SN1 ~= SN2
    if(length(intersect(SpikeSess1(1),SpikeSess2(1)))* ... % Check sessions are on the same day
            length(intersect(SpikeSess1{2},SpikeSess2{2})))%  Check there are overlapping recordings
        if nargin == 3
            tmpSession(1) = DayTrials;
        else
            tmpSession(1) = intersect(SpikeSess1(1),SpikeSess2(1));
        end
        tmpSession{2} = intersect(SpikeSess1{2},SpikeSess2{2});
        tmpSession{3}(1) = sessTower(SpikeSess1);
        tmpSession{3}(2) = sessTower(SpikeSess2);
        Contact1 = sessContact(SpikeSess1);
        Contact2 = sessContact(SpikeSess2);
        
        tmpSession{4}{1} = {sessElectrode(SpikeSess1),Contact1(1)};
        tmpSession{4}{2} = {sessElectrode(SpikeSess2),Contact2(1)};
        
        tmpSession{5} = [SpikeSess1{5},SpikeSess2{5}];
        tmpSession{6} = [sessNumber(SpikeSess1),sessNumber(SpikeSess2)];
        tmpSession{7} = MonkeyName;
        tmpSession{8} = {'Spike','Spike'};
        
        if length(sessTrials(tmpSession,''))>MINSPIKESPIKETRIALS;
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


