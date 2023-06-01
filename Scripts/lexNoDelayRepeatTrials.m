function repeatTrials = lexNoDelayRepeatTrials(trialInfo);
% trialInfo = trialInfo file taken from lex no delay task
% repeatTrials = index of trials that were repeat

counter=0;
repeatTrials=[];
for iTrials=1:length(trialInfo)
    if strcmp(trialInfo{iTrials}.cue,'Repeat')
        repeatTrials(counter+1)=iTrials;
        counter=counter+1;
    end
end