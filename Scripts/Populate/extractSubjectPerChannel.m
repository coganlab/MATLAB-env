function [subjNameAll,chanSubj] = extractSubjectPerChannel(channelNames)
%EXTRACTSUBJECTPERCHANNEL Summary of this function goes here
%   Detailed explanation goes here
subjNameAll = {};
iSubj = 0;
chanSubj = [];
for iChan = 1:numel(channelNames)
    chanName = channelNames{iChan};
    chanNameParse = strsplit(chanName, '-');  % Split the channel name
    subjName = chanNameParse{1};  % Extract the subject name
    if(ismember(subjName,subjNameAll))     
    else
        iSubj = iSubj+1;
        subjNameAll{iSubj} = subjName;        
    end
     chanSubj(iChan) = iSubj;
end
end

