% [channels] = ntools_get_channels(data_type)
%
% For a given file's data type, computes the file's number of channelS

function [channels] = ntools_get_channels(data_type)
%    warning('Deprecated! Will probably be removed soon!');

global experiment

    switch(data_type)
        case {'nspike','decieeg','ieeg', 'cleanieeg','cleandecieeg','low.nspike'},
            if isfield(experiment.recording,'nspike_num_channels_to_write_low')
                channels = experiment.recording.nspike_num_channels_to_write_low;
            else
                channels = 256;
            end
        case {'comedi_audio','audio','videosync','cleancomedi_audio','comedi'}
            channels = 2;
        otherwise
            error('Unknown data_type: "%s"', data_type);
    end
end
