% [precision file_precision sample_size] = ntools_get_precision(data_type)
%
% For a given file's data type, computes the file's internal precision, the
% output precision of fread, and the size of each sample in bytes.

function [precision file_precision sample_size] = ntools_get_precision(data_type)
    global experiment

    switch(data_type)
        case {'nspike','decieeg','audio'}
            sample_size = 2;
            file_precision = 'int16';
            precision = 'int16';
        case {'ieeg', 'cleanieeg','cleandecieeg'}
            sample_size = experiment.processing.ieeg.byte_size;
            file_precision = experiment.processing.ieeg.format;
            precision = 'single';
        otherwise
            error('Unknown data_type: "%s"', data_type);
    end
end
