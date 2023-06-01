function rewrite_triggers_sternberg(trigTimes,trialInfo);
% removes all non first auditory triggers for sternberg neighborhood
counter=0;
counter2=0;
trigTimesA=[];
for iTrials=1:length(trialInfo);
    trigTimesA(counter2+1)=trigTimes(counter+1);
    counter=counter+length(trialInfo{iTrials}.stimulusSounds_idx)-1;
    counter2=counter2+1;
end
    
    