% [channels] = ntools_get_channels(data_type)
%
% For a given file's data type, computes the file's number of channelS

function [channels] = ntools_get_channels(data_type)
    global experiment

    switch(data_type)
        case {'nspike','decieeg','ieeg', 'cleanieeg','cleandecieeg'},
            channels = experiment.recording.nspike_num_channels_to_write_low;
           % channels = 256;
        case {'audio','videosync'}
            channels = 1;
        otherwise
            error('Unknown data_type: "%s"', data_type);
    end
end
