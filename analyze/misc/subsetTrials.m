function Trials = subsetTrials(Trials,CondParams)

% Based on CondParams.trialSubset, subset the trials.

TwoTRewardMagTaskCode = 2;

for i = 1:length(CondParams.trialSubset)
    if(strcmp(CondParams.trialSubset{i},'Choice'))
        Trials = Trials([Trials.Choice] == TwoTRewardMagTaskCode);
    elseif(strcmp(CondParams.trialSubset{i},'Other things'))
        
    end
end
