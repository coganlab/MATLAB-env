
% Define the patterns you want to match using regex
channelName = {Subject(41).ChannelInfo.Name}'
channelName(cellfun(@isempty,channelName)) = {'noName'};
patterns = {'LFO[17-18]','LTP15','LTAM[14-15]','RFO[8-18]'};

% Initialize muscleIds
muscleIds = logical(zeros(1, length(channelName)))';

% Loop through patterns and use regexp to match
for i = 1:length(patterns)
    matches = ~cellfun('isempty', regexp(channelName, patterns{i}));
    muscleIds(matches) = 1;
end

muscleChannel = channelName(muscleIds)
save("muscleChannelWavelet.mat","muscleChannel","muscleIds")

