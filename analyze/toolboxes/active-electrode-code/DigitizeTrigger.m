

function [idx,levels] = DigitizeTrigger(data, trigger_channel, num_levels, numRow)

% This function takes an analog channel with a known number of discrete
% voltage levels and uses kmeans clustering to identify the discrete
% voltage levels and assign each analog sample to one of the discrete
% levels. Essentially, it performs an optimized quantization to num_levels
% discrete levels. 
%
% Inputs:
% 
%   data - all the original data
%   trigger_channel - which analog channel on the system contains the data
%                   (indexed to 1, so a 20 column electrode array would
%                   have the first trigger channel at 21)
%   num_levels - how many discrete voltage levels are in the data. This 
%                would be 2 for binary data, higher for multi level data.
%   numRow - the number of demultiplexed rows in this data
%
%
% Returns:
%   idx - vector of data points, classified to the discrete levels
%   levels - vector of size num_levels that contains the discrete voltage levels
%   that were found

% constants
numReplicates = 10;         % number of times to run kmeans - increase if not finding the minimum, decrease if taking too long
plot_enabled = 'TRUE';      % plots reconstructed and original data for testing

% grab all demuxed channels belonging to the trigger channel
level_data = data((trigger_channel-1)*numRow+1:trigger_channel*numRow,:);

% average all of these channels
level_data = mean(level_data,1);         % sum up all the binary values

% create a uniformly distributed seed vector for kmeans
levels = (min(level_data):(max(level_data)-min(level_data))/(num_levels-1):max(level_data))';


% run kmeans clustering on the voltage data to produce the trigger levels
%warning off all;        % turn off warnings about bad clusters
[idx,levels] = kmeans(level_data,num_levels, 'replicates', numReplicates, 'Display','off', 'start', repmat(levels,[1 1 numReplicates]));
%warning on all;

% display some results
disp(['  Number of voltage levels found in trigger channnel ' num2str(trigger_channel) ': ' num2str(size(levels,1))]);
disp(['  Voltage levels found in trigger channel ' num2str(trigger_channel) ' (V): ']);
disp(num2str(levels));


% reconstruct the trigger channel from the new quantized (clustered) data
test = zeros(size(idx));

% build the vector by replacing the cluster indices with their voltages
for i = 1:size(levels,1)
    test(idx == i) = levels(i);
end

% if enabled, plot a reconstruction of the quantized data and the original
% trigger data to check for consistency
if strcmp(plot_enabled, 'TRUE')
    figure(trigger_channel)
    plot([test';level_data]')
    hline(levels)
end

% print performance metric
recon_error = std(test' - level_data);
disp(['  Standard deviation of trigger channel ' num2str(trigger_channel) ' reconstruction (V) (should be small): ' num2str(recon_error) ]);


end