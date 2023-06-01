
% Constants that will be in a function once done


function [avg_eps,count,x] = multiplexed_ep(data, start_sec, stop_sec, numRow, numCol, numChan, Fs, data_type, ELECTRODE)

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



% EP Consts - IF orientation stim, the response window is long
if strcmp(data_type, 'ORIENT')
    SecsPre = 3;
    SecsPost = 3;
    
    % orientation channel
    % ttl_chan = 15;     % card c channel 0
    % ttl_threshold = 3;  % analog signal threshold
    % rising_edge = 1;
    
    if strcmp(ELECTRODE, 'HDN')
        ttl_chan = 23;     % card c channel 0
        y_chan = 24;
        x_chan = 24;
    end
    
    if strcmp(ELECTRODE, 'RAT')
        ttl_chan = 16;     % card c channel 0
        y_chan = 17;
        x_chan = 18;
    end
end

% If 2d sparse noise, the frame rate is higher, 200 ms + 64 ms dead time
if strcmp(data_type, '2DSPARSE')
    SecsPre = 0;
    SecsPost = 0.26;
    
    % orientation channel
    % ttl_chan = 15;     % card c channel 0
    % ttl_threshold = 3;  % analog signal threshold
    % rising_edge = 1;
    
    if strcmp(ELECTRODE, 'HDN')
        %ttl_chan = 21;     % white stimulus
        ttl_chan = 22;     % black stimulus
        y_chan = 23;
        x_chan = 24;
    end
    
    if strcmp(ELECTRODE, 'RAT')
        ttl_chan = 16;     % card c channel 0
        y_chan = 17;
        x_chan = 18;
    end
    
end

% Electrical Stim
if strcmp(data_type, 'STIM')
    SecsPre = 0.5;
    SecsPost = 1.5;
    
    % orientation channel
    % ttl_chan = 15;     % card c channel 0
    % ttl_threshold = 3;  % analog signal threshold
    % rising_edge = 1;
    
    if strcmp(ELECTRODE, 'HDN')
        ttl_chan = 21;     % card c channel 0
        y_chan = 21;
        x_chan = 21;
    end
    
end






% orientation pulse channel


if strcmp(data_type, 'ORIENT')
    number_x_levels = 9;
    number_y_levels = 1;
    invert_x = 'FALSE';
    invert_y = 'FALSE';
    
    trigger_edge = 'RISING';
    %trigger_edge = 'FALLING';
    %trigger_edge = 'BOTH';
    
    ttl_threshold = 2.5;  % 2.5V logic threshold
end


if strcmp(data_type, '2DSPARSE')
    number_x_levels = 8;
    invert_x = 'TRUE';
    
    number_y_levels = 8;
    invert_y = 'FALSE';
    
    trigger_edge = 'RISING';
    %trigger_edge = 'FALLING';
    %trigger_edge = 'BOTH';
    
    ttl_threshold = 2.5;  % 2.5V logic threshold
end

if strcmp(data_type, 'STIM')
 number_x_levels = 1;
    invert_x = 'FALSE';
    
    number_y_levels = 1;
    invert_y = 'FALSE';
    
    trigger_edge = 'RISING';
    ttl_threshold = .2;  % 2.5V logic threshold
end

level_set_delay = 0.1;    % how many seconds offset from the trigger should we look for the voltage level corresponding to this orientation or location


% how many samples to grab before and after the trigger
SampsPre = floor(Fs * SecsPre);
SampsPost = floor(Fs * SecsPost);


% grab all demuxed channels belonging to the trigger channel
ttl_data = data((ttl_chan-1)*numRow+1:ttl_chan*numRow,:);
%ttl_data = data(33,:);

ttl_data = ttl_data > ttl_threshold;    % threshold to binary
ttl_data = sum(ttl_data,1);         % sum up all the binary values
ttl_data = ttl_data > 0.5;      % threshold again, if any of the demux channels had a 1, keep it
ttl_data = diff(ttl_data);      % diff digital signal

% obtain the orientation levels for this data

% one multi-level signal is common to both experiment types
if strcmp(data_type, 'ORIENT') || strcmp(data_type, '2DSPARSE') || strcmp(data_type, 'STIM')
    if strcmp(invert_x, 'TRUE')
        [x_assignments,x_levels] = DigitizeTrigger(-data, x_chan, number_x_levels, 1);
    else
        [x_assignments,x_levels] = DigitizeTrigger(data, x_chan, number_x_levels, 1);
    end
end

% orientation stim only has X data
if strcmp(data_type, 'ORIENT') || strcmp(data_type, 'STIM')
    y_assignments = ones(size(x_assignments));
end

% 2-d sparse noise has two multi-level triggers for x, y coordinates
if  strcmp(data_type, '2DSPARSE')
    if strcmp(invert_y, 'TRUE')
        [y_assignments,y_levels] = DigitizeTrigger(-data, y_chan, number_y_levels, numRow);
    else
        [y_assignments,y_levels] = DigitizeTrigger(data, y_chan, number_y_levels, numRow);
    end
end


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
        
        x = x_assignments(idx + round(level_set_delay*Fs) );
        y = y_assignments(idx + round(level_set_delay*Fs) );
        
        count(x,y) = count(x,y) + 1; % counter
        
        % grab the evoked reponse trial
        ep = data(:,idx-SampsPre:idx+SampsPost-1);
        
        % grab the snip of the trace
        avg_eps(x,y,count(x,y),:,:) = reshape(ep,1, 1, 1, num_chan , num_samp );
    end
end

disp(['  Number of triggers at each orientation : ']);
disp(num2str(count));

% cleanup stim results to min size
if strcmp(data_type, 'ORIENT')
    
    % 0th orientation is null state between trials, discard
    avg_eps = avg_eps(2:end,:,:,:,:);
    count = count(2:end);
    
    avg_eps = avg_eps(:,:,1:min(min(count)),:,:);
    
end

if  strcmp(data_type, '2DSPARSE') || strcmp(data_type, 'STIM')
    avg_eps = avg_eps(:,:,1:min(min(count)),:,:);
end


% normalize by number of eps
% for i = 1:number_orientations
%
%     if count(i) ~= 0
%         avg_eps(i,:,:) = avg_eps(i,:,:) ./ count(i);
%     end
%
% end
%








