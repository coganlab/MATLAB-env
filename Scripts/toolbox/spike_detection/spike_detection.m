%% Spike code to find the mid point of spikes
% Created by Aaron Choong and Jesslyn Sutanti
% Last modified 10/8/2017
% Supervised by Kostas, Yan & Masoud

function [spikes_index] = spike_detection(spike_data,threshold)
%% This spike code finds the mid point of the spikes instead of the peaks
% Faster computation than spike_times (~5x faster for big data)

%-----------------------------%
% INPUT VARIABLES DEFINITIONS %
%-----------------------------%

% 1) spike_data holds the raw neural data with voltage values (the index will be its time value)
% 2) threshold is the voltage level where the spikes are thresholded against

%------------------------------%
% OUTPUT VARIABLES DEFINITIONS %
%------------------------------%

% 1) spikes is an array of all the time stamps of the middle of the spikes

%% Initialisation of variables
spike_index = find((spike_data)>threshold);    % Temporary variable to hold trace of the spikes (all values above the spike threshold is recorded)
spike_index_array = zeros(1,length(spike_index));    % To hold all the midpoint of spikes
i=1;                                    % Index of spike_index matrix


%% Start of spike sorting 
while ( i < length(spike_index))
    n=1; % To hold how much values it should skip
    temp_var = 0;
    while((spike_index(i) == spike_index(i+n)-n) && i+n<length(spike_index)) % This loop checks if the next element in the array corresponds to the same spike
        n=n+1; % Increments if the next raw neural data corresponds to the same spike                                             
        if(temp_var<spike_data(spike_index(i+n)))
            temp_var = spike_data(spike_index(i+n));    
            spike_index_array(1,i) = spike_index(i+n);  % Holds the peak of the spike
        end 
    end 

    i=i+n;                              % Increment i by the skip value
end                                     % End of while-loop

%% Allocating output matrix 
spikes_index = spike_index_array(spike_index_array~=0);   % Allocate the output as a non-zero array 


end 