subjNames = extractfield(Subject,'Name');
subjName = 'D91';
subjId = find(ismember(subjNames,subjName));
channelName = {Subject(subjId).ChannelInfo.Name}';
channelName(cellfun(@isempty, channelName)) = {'noName'};

% Patterns with explicit ranges
patternRanges = {
    'LTAS', 7, 8;
    'LTAI', 13, 15;
    'LFAM', 15, 15;   
    'LTP', 1, 12;
    'LTMM', 13, 15;
    'LTPM', 14, 15;
    'LTMI', 12, 14;
    'LTLI',14, 14;
    'LFAI', 9, 9;
};

% Initialize muscleIds
muscleIds = false(1, length(channelName));

% Generate patterns with ranges and match them
for i = 1:size(patternRanges, 1)
    basePattern = patternRanges{i, 1};
    startRange = patternRanges{i, 2};
    endRange = patternRanges{i, 3};
    
    % Dynamically create the pattern for current range
    pattern = [basePattern, generatePatternForRange(startRange, endRange)];
    
    % Match the dynamically created pattern
    matches = ~cellfun('isempty', regexp(channelName, pattern));
    muscleIds(matches) = true;
end
muscleChannel = channelName(muscleIds)
save("muscleChannelWavelet.mat","muscleChannel","muscleIds")

function patternStr = generatePatternForRange(startNum, endNum)
    if startNum == endNum
        patternStr = sprintf('(?<!\\d)%d(?!\\d)', startNum);
    else
        numPatterns = arrayfun(@(x) sprintf('(?<!\\d)%d(?!\\d)', x), startNum:endNum, 'UniformOutput', false);
        patternStr = ['(', strjoin(numPatterns, '|'), ')'];
    end
end
