
function [spikeTimes, spikeDelays, rmsVals, spikes] = SpikeFind(data, startSec, stopSec, numRow, numCol, Fs, plotEn)


SecsPre = 0.050;
SecsPost = 0.050;

spike_threshold = 1e-4;     % threshold to detect a spike in the average trace
rms_threshold = 0.4;        % save spikes if the rms max / median is > 0.4

trigger_edge = 'RISING';
%trigger_edge = 'FALLING';
%trigger_edge = 'BOTH';


% pull electrode data out  (no negate, already done elsewhere)
data = data(1:numRow*numCol,:);

% if start / stop provided, grab data
if (~isempty(startSec)) && (~isempty(stopSec))
    data = data(:,floor(startSec*Fs)+1:floor(stopSec*Fs));
end

% how many samples to grab before and after the trigger
SampsPre = floor(Fs * SecsPre);
SampsPost = floor(Fs * SecsPost);


% create average trace
xAvg = mean(data,1);

% init time vector
t = 0:1/Fs:(size(xAvg,2)-1)*1/Fs;


ttl_data = xAvg > spike_threshold;    % threshold to binary

ttl_data = diff(ttl_data);      % diff digital signal


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
fprintf('total number of threshold crossings: %d\n',size(pulsesTTL,2));


spikeCount = 0;

spikeDelays = [];
rmsVals = [];
spikes = [];
spikeTimes = [];

% Loop over the TTL pulse indexes
for i = 1:size(pulsesTTL,2)
    
    % make sure we have enough data before and after the trigger to be able
    % to use this average (boundry condition check)
    if (pulsesTTL(i) > SampsPre) && (pulsesTTL(i) < size(data,2)- SampsPost)
        
        idx = pulsesTTL(i);
        
        % check for refractory period
        if (i > 1) && (idx > (pulsesTTL(i-1) + SampsPre + SampsPost))
            
            trigInWindow = ttl_data(idx-SampsPre:idx+SampsPost-1);
            
            % only take this spike if there is only 1 positive and negative
            % threshold crossing in the window... ignore poly spikes for now
            %if (sum(trigInWindow == 1) == 1) && (sum(trigInWindow == -1) == 1)
            
            if (find(trigInWindow == -1) > SampsPre)
                
                % grab the evoked reponse trial
                ep = data(:,idx-SampsPre:idx+SampsPost-1);
                
                % grab the snip of the trace
                %spikes(spikeCount,:,:) = reshape(ep,1, num_chan , num_samp);
                
                % optional spike plots
                if strcmp(plotEn, 'TRUE')
                    avgInWindow = xAvg(idx-SampsPre:idx+SampsPost-1);
                    
                    t = idx-SampsPre:idx+SampsPost-1;   % compute a time vector
                    t = t ./Fs;                 % convert to seconds
                    % if start / stop provided, add back in offset
                    if (~isempty(startSec)) && (~isempty(stopSec))
                        t = t + startSec;
                    end
                    
                    figure(10)
                    subplot(3,1,1)
                    plot(t, trigInWindow)
                    subplot(3,1,2)
                    plot(t, avgInWindow)
                    subplot(3,1,3)
                    plot(t, ep')
                    
                    %convert2Movie (ep, 'spike', [], [], t(1), numRow, numCol, Fs);
                    
                    %pause(0.05)
                    %pause
                    
                end
                
                
                % calculate the correlation for each spike
                [delayMap, rmsMap] = SpikeCorr (ep, [], [], t(1), numRow, numCol, Fs, plotEn);
                
                
                if (median(rmsMap(:)) / max(rmsMap(:))) > rms_threshold
                    spikeCount = spikeCount + 1; % counter
                    
                    spikeDelays(spikeCount,:) = delayMap;
                    rmsVals(spikeCount,:) = rmsMap;
                    

                    spikes(spikeCount,:,:) = reshape(ep,1,size(ep,1), size(ep,2));

                    % test plot
%                     figure(1)
%                     sig = mean(ep,1);
%                     t = 0:1/Fs:(size(sig,2)-1)*1/Fs;
%                     t = t - SecsPre;
%                     E = std(ep,0,1);
%                     errorbar(t,sig,E)
%                     figure(2)
%                     plot(t,ep')
%                     pause
                    
                    % spike time variable in seconds
                    spikeTimes(spikeCount) = idx / Fs;
                    
                    % if start / stop provided, add back in offset
                    if (~isempty(startSec)) && (~isempty(stopSec))
                        spikeTimes(spikeCount) = spikeTimes(spikeCount) + startSec;
                    end
                else
                    disp('skipped spike below RMS threshold');
                end
                
                disp(['finished spike ' num2str(i) ' of ' num2str(size(pulsesTTL,2))]);
                
                if strcmp(plotEn, 'TRUE')
                    pause
                end
            else
                disp('out of order spike skipped');
            end  % check for negative threshold crossings before positive ones
        else
            disp('refractory spike skipped')
        end  % check for refractory period
        
        
    end  % check for enough data before and after trigger for a full trace
end

disp(['  Number of spikes found : ' num2str(spikeCount)]);


