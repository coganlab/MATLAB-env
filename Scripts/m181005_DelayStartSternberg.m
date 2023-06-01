ii=find(triggerIdent>=101 & triggerIdent<=104);

for iTrials=1:length(trialInfo)
    if iTrials<length(trialInfo)
    timeRange=triggerTimes(ii(iTrials)):triggerTimes(ii(iTrials+1));
    else
    timeRange=triggerTimes(ii(iTrials)):length(eegCA);
    end
    idx=find(triggerTimes>timeRange(1) & triggerTimes<timeRange(end));
    ii2=find(triggerIdent(idx)==trialInfo{iTrials}.StimulusSounds_idx(end));
    delayStart(iTrials)=triggerTimes(idx(ii2(1)))+1250;
    probeStart(iTrials)=triggerTimes(ii(iTrials)+length(trialInfo{iTrials}.StimulusSounds_idx)+1);
    maintenanceStart(iTrials)=trialInfo{iTrials};
    
end
    
    delay=cat(1,ones(1,length(trialInfo)),delayStart);
    probe=cat(1,ones(1,length(trialInfo)),probeStart);
       
        
        