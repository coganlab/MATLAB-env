for iTrials=1:length(trialInfo);
    RTs(iTrials)=trialInfo{iTrials}.ReactionTime;
    if strcmp(trialInfo{iTrials}.StimulusCategory,'High Words')
        condVals(iTrials)=1;
    elseif strcmp(trialInfo{iTrials}.StimulusCategory,'Low Words')
        condVals(iTrials)=2;
    elseif strcmp(trialInfo{iTrials}.StimulusCategory,'High Non-Words')
        condVals(iTrials)=3;
    elseif strcmp(trialInfo{iTrials}.StimulusCategory,'Low Non-words')
        condVals(iTrials)=4;
    end
    
    if strcmp(trialInfo{iTrials}.ProbeCategory,'High Words')
        probeVals(iTrials)=1;
    elseif strcmp(trialInfo{iTrials}.ProbeCategory,'Low Words')
        probeVals(iTrials)=2;
    elseif strcmp(trialInfo{iTrials}.ProbeCategory,'High Non-Words')
        probeVals(iTrials)=3;
    elseif strcmp(trialInfo{iTrials}.ProbeCategory,'Low Non-words')
        probeVals(iTrials)=4;
    end
    if strcmp(trialInfo{iTrials}.ProbeTypeName,'in_sequence')
        sequenceVals(iTrials)=1;
    else
        sequenceVals(iTrials)=2;
    end
    stimLength(iTrials)=length(trialInfo{iTrials}.StimulusSounds_idx);
end
