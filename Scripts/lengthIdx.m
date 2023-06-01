function trialLengthIdx = lengthIdx(trialInfo)

for iTrials=1:length(trialInfo)
    if isfield(trialInfo{1},'StimulusSounds_idx')
    trialLengthIdx(iTrials)=length(trialInfo{iTrials}.StimulusSounds_idx);
    elseif isfield(trialInfo{1},'stimulusSounds_idx')
    trialLengthIdx(iTrials)=length(trialInfo{iTrials}.stimulusSounds_idx);
    end
end