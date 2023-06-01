function probeIdx = probeIdx(trialInfo)

for iTrials=1:length(trialInfo)
    if isfield(trialInfo{1},'ProbeType') && strcmp(trialInfo{iTrials}.ProbeTypeName,'in_sequence')
        probeIdx(iTrials)=1;
    elseif isfield(trialInfo{1},'ProbeType') && strcmp(trialInfo{iTrials}.ProbeTypeName,'out_of_sequence')
        probeIdx(iTrials)=0;
    elseif isfield(trialInfo{1},'ProbeCategory') && trialInfo{iTrials}.ProbeCategory==1
        probeIdx(iTrials)=1;
    elseif isfield(trialInfo{1},'ProbeCategory') && trialInfo{iTrials}.ProbeCategory==0
        probeIdx(iTrials)=0; 
    end
end