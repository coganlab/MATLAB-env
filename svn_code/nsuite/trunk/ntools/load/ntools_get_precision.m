% [precision file_precision sample_size] = ntools_get_precision(data_type)
%
% For a given file's data type, computes the file's internal precision, the
% output precision of fread, and the size of each sample in bytes.

function [precision file_precision sample_size] = ntools_get_precision(data_type)
    global experiment

    switch(data_type)
        %case {'nspike','decieeg','audio','comedi_audio','low.nspike'}
        case {'nspike','decieeg','audio','low.nspike'}
            sample_size = 2;
            file_precision = 'int16';
            precision = 'int16';
        case {'cleancomedi_audio'}
            sample_size = 4;
            file_precision = 'float';
            precision = 'single';
        case {'comedi_audio','comedi'}
            %sample_size = experiment.processing.comedi.audio.byte_size;
            sample_size=2;
            %file_precision = experiment.processing.comedi.audio.format;
            
           % file_precision='int16'; % NY149?
           % precision='int16'; % NY149?
            
            %file_precision='short';
            %precision='short';
            
           file_precision='ushort'; %normal
            precision = 'ushort'; % normal
            
        case {'ieeg', 'cleanieeg','cleandecieeg'}
            sample_size = experiment.processing.ieeg.byte_size;
            file_precision = experiment.processing.ieeg.format;
            precision = 'single';
        otherwise
            error('Unknown data_type: "%s"', data_type);
    end
end
