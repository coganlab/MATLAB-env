
% Constants that will be in a function once done


function [avg_eps,count,x] = vep_average(data, start_sec, stop_sec, SecsPre, SecsPost, numRow, Fs, data_type, x_assignments, number_x_levels, invert_x, y_assignments, number_y_levels, invert_y, c_assignments, c_type, ttl_chan, trigger_edge, ttl_threshold, level_set_delay)

% data - the data
% start_sec - how many seconds into the file to start
% stop_sec - how many seconds to discard from the end of the file
% numRow - number of electrode rows
% numCol - number of electrode columns
% numChan - number of analog channels
% Fs - sampling rate of the data
% data_type - string describing the experiment
%             'ORIENT' - moving sinusoidal gratings
%             '2DSPARSE' - 2d sparse noise
% electrode - electrode type
% level_set_delay - % how many seconds offset from the trigger should we look for the voltage level corresponding to this orientation or location


% how many samples to grab before and after the trigger
SampsPre = floor(Fs * SecsPre);
SampsPost = floor(Fs * SecsPost);

% toss out excluded data
data = data(:,round(start_sec*Fs):end-round(stop_sec*Fs));


% grab all demuxed channels belonging to the trigger channel
ttl_data = data(ttl_chan,:);
ttl_data = ttl_data > ttl_threshold;    % threshold to binary
ttl_data = diff(ttl_data);      % diff digital signal

% obtain the orientation levels for this data

% % one multi-level signal is common to both experiment types
% if strcmp(data_type, 'ORIENT') || strcmp(data_type, '2DSPARSE') || strcmp(data_type, 'STIM')
%     if strcmp(invert_x, 'TRUE')
%         [x_assignments,x_levels] = DigitizeTrigger(-data, x_chan, number_x_levels, numRow);
%     else
%         [x_assignments,x_levels] = DigitizeTrigger(data, x_chan, number_x_levels, numRow);
%     end
% end

% % orientation stim only has X data
% if strcmp(data_type, 'ORIENT') || strcmp(data_type, 'STIM')
%     y_assignments = ones(size(x_assignments));
% end
% 
% % 2-d sparse noise has two multi-level triggers for x, y coordinates
% if  strcmp(data_type, '2DSPARSE')
%     if strcmp(invert_y, 'TRUE')
%         [y_assignments,y_levels] = DigitizeTrigger(-data, y_chan, number_y_levels, numRow);
%     else
%         [y_assignments,y_levels] = DigitizeTrigger(data, y_chan, number_y_levels, numRow);
%     end
% end


% single pulse code - get times of edges, either rising, falling or both
% edges
if strcmp(trigger_edge, 'RISING')
    pulsesTTL = find(ttl_data == 1);
end

if strcmp(trigger_edge, 'FALLING')
    pulsesTTL = find(ttl_data == -1);
end

if strcmp(trigger_edge, 'BOTH')
    pulsesTTL = [find(ttl_data == 1)  find(ttl_data == -1)];
end


% print number of triggers
fprintf('total number of triggers: %d\n',size(pulsesTTL,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Now that we have the trigger signal, average....

num_chan = size(data,1);
num_samp = SampsPre+SampsPost;

if  strcmp(data_type, '2DSPARSE') 
    estimate_number_trials_per_orientation = ceil(size(pulsesTTL,2) / number_x_levels);
end

if strcmp(data_type, 'ORIENT') || strcmp(data_type, 'STIM')
    estimate_number_trials_per_orientation = ceil(size(pulsesTTL,2) / (number_x_levels-2));
end

% alloc space
avg_eps = zeros(number_x_levels,number_y_levels,estimate_number_trials_per_orientation,num_chan,SampsPre+SampsPost);

% x vector
x = -SecsPre:1/Fs:SecsPost-1/Fs;

% count of triggers
count = zeros(number_x_levels,number_y_levels);

% Loop over the TTL pulse indexes
for i = 1:size(pulsesTTL,2)
    
    % make sure we have enough data before and after the trigger to be able
    % to use this average (boundry condition check)
    if (pulsesTTL(i) > SampsPre) && (pulsesTTL(i) < size(data,2)- SampsPost)
        
        
        idx = floor(pulsesTTL(i));
        
%         x = x_assignments(idx + round(level_set_delay*Fs) );
%         y = y_assignments(idx + round(level_set_delay*Fs) );
%         
        x = x_assignments(i);
        y = y_assignments(i);
        c = c_assignments(i);
        
        if c == c_type
            
            count(x,y) = count(x,y) + 1; % counter
            
            % grab the evoked reponse trial
            ep = data(:,idx-SampsPre:idx+SampsPost-1);
            
            % grab the snip of the trace
            avg_eps(x,y,count(x,y),:,:) = reshape(ep,1, 1, 1, num_chan , num_samp );
        end
    end
end

disp(['  Number of triggers at each orientation : ']);
disp(num2str(count));

% cleanup stim results to min size
if strcmp(data_type, 'ORIENT_DIEGO')
    
    % 0th orientation is null state between trials, discard
    avg_eps = avg_eps(2:end,:,:,:,:);
    count = count(2:end);
    
    avg_eps = avg_eps(:,:,1:min(min(count)),:,:);
    
end

if  strcmp(data_type, '2DSPARSE') || strcmp(data_type, 'STIM') || strcmp(data_type, 'ORIENT')
    avg_eps = avg_eps(:,:,1:min(min(count)),:,:);
end







