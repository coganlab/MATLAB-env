function numTrigs = triggerNumSternberg(trialInfo);

numTrigs=0;
for iTrials=1:length(trialInfo);
    numTrigs=numTrigs+length(trialInfo{iTrials}.stimulusSounds_idx)+1;
end

% numTriggers should equal trigTimes
% command line: numTriggers=triggerNumSternberg(trialInfo);
    