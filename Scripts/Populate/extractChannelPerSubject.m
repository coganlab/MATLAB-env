function channelIds = extractChannelPerSubject(channelNames,subjectNames)
    channelIds = false(size(channelNames));
    for iChan = 1:numel(channelNames)
            chanName = channelNames{iChan};
            chanNameParse = strsplit(chanName, '-');  % Split the channel name
            subjName = chanNameParse{1};  % Extract the subject name
            subjId = strcmp(subjectNames, subjName);  % Use logical indexing to find the subject ID
            if(subjId)
            channelIds(iChan) = true;
            end
    end
end

