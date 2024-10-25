function [ieegMeanAll,ieegMean,ieegSubj] = extractMeanControlSubject(ieeg,channelName)
%EXTRACTMEANCONTROLSUBJECT Summary of this function goes here
%   Detailed explanation goes here
[~,chanSubj] = extractSubjectPerChannel(channelName);

uniqueSubj = unique(chanSubj);
ieegMean = [];
for iSubj = 1:length(uniqueSubj)
    ieegMeanSubj = mean(ieeg(chanSubj==iSubj,:),1);
    ieegMean = cat(1,ieegMean,ieegMeanSubj);
    ieegSubj{iSubj} = ieeg(chanSubj==iSubj,:);
end

ieegMeanAll = mean(ieegMean,1);
end

