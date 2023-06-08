% ntools_load_int(data_type, filename, start_samp, stop_samp, downsample_factor)
%
% Loads data from a given datafile starting with start_samp (inclusive)
% and ending at end_samp (inclusive) into a matlab matrix in [channel,sample]
% format. If start_samp and stop_samp are empty, it loads the entire file.
%
% example: data = ntools_load_int('rec001.nspike.dat', 100, 200)

function data = ntools_load_int(data_type, filename, start_samp, stop_samp, downsample_factor)
    if(~exist('downsample_factor', 'var') || isempty(downsample_factor))
        %disp('No downsample_factor in ntools_load_int. Setting to 1');
        downsample_factor = 1;
    elseif(downsample_factor - round(downsample_factor) ~= 0)
        error('downsample_factor must be an integer for now');
    end

    [fid, message] = fopen(filename); if(fid == -1), error(message); end
    channels = ntools_get_channels(data_type);

    [precision file_precision sample_size] = ntools_get_precision(data_type);
    fread_precision = [file_precision '=>' precision];

    if(~exist('start_samp', 'var') || isempty(start_samp))
        start_byte = 0;
        data_range = Inf;
    else
        % we want to include start_samp
        start_byte = (start_samp-1)*channels*sample_size;
        if start_byte < 0
            start_byte = 0;
        end
        data_range = stop_samp - start_samp + 1;
    end

    status = fseek(fid, start_byte, 'bof');
    if status == -1
        ferror(fid)
    end

    %Reads one sample, then skips over downsample_factor-1 samples
    data = fread(fid, [channels, round(data_range / downsample_factor)], ...
        [num2str(channels) '*' fread_precision], (downsample_factor-1)*channels*sample_size);

    fclose(fid);
end
