function channelInfoAll = extractChannelLocation(Subject, channelNames)
    % EXTRACTCHANNELLOCATION Extract anatomical information of channel names
    %   Subject: Structure array containing subject information
    %   channelNames: Cell array of channel names
    
    subjectNames = {Subject.Name};  % Extract subject names using indexing
    channelInfoAll = struct('Name', cell(1, numel(channelNames)), 'Location', []);
    
    % Iterate over each channel name
    for iChan = 1:numel(channelNames)
        chanName = channelNames{iChan};
        chanNameParse = strsplit(chanName, '-');  % Split the channel name
        subjName = chanNameParse{1};  % Extract the subject name
        subjId = strcmp(subjectNames, subjName);  % Use logical indexing to find the subject ID
        
        if any(subjId)  % If subject exists
            chanInfoSubject = Subject(subjId).ChannelInfo;  % Get the channel information for the subject
            chanNameSubject = {chanInfoSubject.Name};  % Extract channel names using indexing
            chanId = strcmp(chanNameSubject, chanName);  % Use logical indexing to find the channel ID
            
            if any(chanId)  % If channel exists
                % Store channel information in channelInfoAll
                channelInfoAll(iChan).Name = channelNames{iChan};
                channelInfoAll(iChan).Location = chanInfoSubject(chanId).Location;
            end
        end
    end
end

