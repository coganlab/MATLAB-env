function channelInfoAll = poolChannelInfo(Subject)
    % POOLCHANNELINFO Pool channel information from multiple subjects
    %   Subject: Structure array containing subject information
    
    channelInfoAll = [];
    
    % Iterate over each subject
    for iSubject = 1:length(Subject)
        % Concatenate channel information from the current subject to channelInfoAll
        channelInfoAll = [channelInfoAll Subject(iSubject).ChannelInfo];
    end
end