function procRewardBlockTrial(day)
%  PROCREWARDBLOCKTRIAL loads Events for all recs and assigns an
%  index to each trial corresponding to its location in a given reward
%  block.
%
%  PROCREWARDBLOCKTRIAL(DAY)
%
%  Inputs:  DAY    = String '030603'

global MONKEYDIR

recs = dayrecs(day);
nRecs = length(recs);

dayDir = [MONKEYDIR '/' day];

lastRewardTask = -1;
lastRewardDist = zeros(1,4);
rewardBlockTrial = 1;
for k=1:nRecs
  eval(['load ' dayDir '/' recs{k} '/rec' recs{k} '.Events.mat']);
  RewardTask = Events.RewardTask;
  RewardDist = Events.RewardDist;
  RewardBlockTrial = [];
  nTrials = length(RewardTask);
  for t=1:nTrials
    if RewardTask(t)~=lastRewardTask | ~ismember(RewardDist(t,:),lastRewardDist,'rows')
      rewardBlockTrial = 1;
      lastRewardTask = RewardTask(t);
      lastRewardDist = RewardDist(t,:);
    end
    RewardBlockTrial(t) = rewardBlockTrial;
    rewardBlockTrial = rewardBlockTrial + 1;
  end 
  Events.RewardBlockTrial = RewardBlockTrial;
  eval(['save ' dayDir '/' recs{k} '/rec' recs{k} '.Events.mat']);
end
