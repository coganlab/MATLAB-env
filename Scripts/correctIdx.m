function trialCorrectIdx = correctIdx(trialInfo)

for iTrials=1:length(trialInfo)
    if isfield(trialInfo{1},'ResponseCorrect')
    trialCorrectIdx(iTrials)=trialInfo{iTrials}.ResponseCorrect;
    elseif isfield(trialInfo{1},'RespCorrect')
    trialCorrectIdx(iTrials)=trialInfo{iTrials}.RespCorrect;
    end 
end