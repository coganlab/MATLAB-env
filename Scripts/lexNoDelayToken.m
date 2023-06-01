function [idx blockNum] = lexNoDelayToken(wavInput,trialInfo);
%idx = index of trials with the wavInput as a sound (for all trial types)
%blockNum = block number (recall, the 'shuffle' shouldn't affect other blocks
%wavInput = input wav file (e.g. folip.wav)
%trialInfo = trialInfo file from lexNoDelay
counter=0;
for iTrials=1:length(trialInfo)
    if strcmp(trialInfo{iTrials}.sound,wavInput)
        idx(counter+1)=iTrials;
        blockNum(counter+1)=trialInfo{iTrials}.block;
        counter=counter+1;
    end
end