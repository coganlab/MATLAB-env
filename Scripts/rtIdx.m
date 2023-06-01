function trialRTIdx = rtIdx(trialInfo)

for iTrials=1:length(trialInfo)
    trialRTIdx(iTrials)=trialInfo{iTrials}.ReactionTime;
end