%  epoch_data = ntools_gen_epoch_data(data_type, recording, ['channels', wh_channels_to_keep], ['sfreq', new_samp_rate], ['max_epochs', max_epochs])
%
%  Generate an epoch_data data structure from a recording data_structure
%
%  Parameters:
%       data_type: 'ieeg', 'cleanieeg', or 'nspike'
%       recording: recording structure
%
%  Optional keyword parameters:
%       channels: which channels to keep (default: all)
%       sfreq: new sampling rate of epoch_data (default: same as file)
%       max_epochs: max num epochs (default: no limit)
%
%  NB: This should not be called directly. Instead, call
%  ntools_gen_nspike_epoch_data, ntools_gen_ieeg_epoch_data, or ntools_gen_cleanieeg_epoch_data

function epoch_data = ntools_gen_epoch_data(data_type, recording, varargin)
    max_epochs = [];
    new_sfreq = [];
    wh_channels_to_keep = 1:length(recording.settings.channels);
    
    for i = 1:length(varargin)
        if(ischar(varargin{i}))
            switch(lower(varargin{i}))
                case {'max_epochs', 'max epochs'}
                    max_epochs = varargin{i+1};
                case {'new_sfreq', 'sfreq'}
                    new_sfreq = varargin{i+1};
                case {'wh_channels_to_keep', 'channels'}
                    wh_channels_to_keep = varargin{i+1};
            end
        end
    end        
    

    data_file = data_file_name(data_type, recording.recording_filename_root);

    epoch_data = [];
    epoch_data = set_sensor_info(epoch_data, recording, wh_channels_to_keep);
    epoch_data = set_coor_trans(epoch_data);
    epoch_data = set_noise(epoch_data);
    epoch_data = set_sfreq(data_type, epoch_data, recording, new_sfreq);
    epoch_data = set_epochs(data_type, epoch_data, recording, data_file, max_epochs, wh_channels_to_keep, new_sfreq);
end

function data_file = data_file_name(data_type, filename_root)
    switch(data_type)
        case 'nspike'
            data_file = [filename_root '.nspike.dat'];
        case 'ieeg'
            data_file = [filename_root '.ieeg.dat'];
        case 'cleanieeg'
            data_file = [filename_root '.cleanieeg.dat'];
        otherwise
            error('Unknown data_type: "%s"', data_type);
    end
end

function epoch_data = set_sensor_info(epoch_data, recording, wh_channels_to_keep)
    %NUM_NSPIKE_SENSORS = 256;

    epoch_data.num_sensors = length(wh_channels_to_keep);
    for i = wh_channels_to_keep
        epoch_data.sensor_info(i).label = recording.settings.channels(i).name;
        epoch_data.sensor_info(i).typestring = 'eeg';
        epoch_data.sensor_info(i).type = 1;
        epoch_data.sensor_info(i).kind = 2;
        epoch_data.sensor_info(i).badchan = 0;
        epoch_data.sensor_info(i).lognum = i; %% isn't this redundant?
        epoch_data.sensor_info(i).loc = eye(4);
    end
end

function epoch_data = set_coor_trans(epoch_data)
    epoch_data.coor_trans.device2head = eye(4);
    epoch_data.coor_trans.mri2head = [];
end

function epoch_data = set_noise(epoch_data)
    epoch_data.noise.num_trials = [];
    epoch_data.noise.num_samples = [];
    epoch_data.noise.covar = [];
end

function epoch_data = set_sfreq(data_type, epoch_data, recording, new_sfreq)
    if(~isempty(new_sfreq))
        epoch_data.sfreq = new_sfreq;
    else
        epoch_data.sfreq = get_dat_file_sfreq(data_type, recording);
    end
end

function epoch_data = set_epochs(data_type, epoch_data, recording, data_file, max_epochs, wh_channels_to_keep, new_sfreq)
    if(isempty(new_sfreq))
        new_sfreq = epoch_data.sfreq;
    end
        
    NSPIKE_SAMPLING_RATE = 3e4;  %  NSpike timestamps are in Nspike system sampling rate
    file_sfreq = get_dat_file_sfreq(data_type, recording);
    downsample_factor = file_sfreq / new_sfreq;
    file_sfreq_to_nspike_sfreq_ratio = file_sfreq / NSPIKE_SAMPLING_RATE;
    file_samples_per_ms = file_sfreq / 1000;
    new_samples_per_ms = new_sfreq / 1000;

    
    num_channels = length(wh_channels_to_keep);
    
    switch(data_type)
        case 'nspike'
            load_int_fun = @ntools_nspike_load_int;
        case 'ieeg'
            load_int_fun = @ntools_ieeg_load_int;
        case 'cleanieeg'
            load_int_fun = @ntools_clean_load_int;
    end
    precision = ntools_get_precision(data_type);

    for i = 1:length(recording.event)
        epoch_data.epochs(i).event_code = recording.event(i).source_code;
        epoch_data.epochs(i).num_trials = length(recording.event(i).timestamps);
        epoch_data.epochs(i).num_rejects = struct('mag', 0, 'grad', 0, 'eeg', 0, 'eog', 0, 'manual', 0, 'skip', 0);

        % offsets in ms
        start_offset = recording.event(i).start_offset;
        stop_offset = recording.event(i).stop_offset;
        
        num_samples = round((stop_offset - start_offset) * new_samples_per_ms);
        
        epoch_data.epochs(i).time = linspace(start_offset, stop_offset, num_samples) / 1000;

        if ~isempty(max_epochs)
            num_trials = min(length(recording.event(i).timestamps), max_epochs);
        else
            num_trials = length(recording.event(i).timestamps);
        end
        if(num_trials == 0)
            error('No trials/epochs found in recording. Use gen_cont_data for continuous data.');
        end
        epoch_data.epochs(i).data = zeros(num_channels, num_samples, num_trials, precision);

        for j = 1:num_trials
            timestamp = recording.event(i).timestamps(j); % in 30 kHz
            start = round(timestamp * file_sfreq_to_nspike_sfreq_ratio + start_offset * file_samples_per_ms);
            stop = round(timestamp * file_sfreq_to_nspike_sfreq_ratio + stop_offset * file_samples_per_ms) - 1;
            data = load_int_fun(data_file, start, stop, downsample_factor);
            epoch_data.epochs(i).data(:, :, j) = data(wh_channels_to_keep, :); %#ok<BDSCI>
        end
    end
end

function sfreq = get_dat_file_sfreq(data_type, recording)
    global experiment

    switch(data_type)
        case 'nspike'
            sfreq = recording.settings.sample_rate;
        case {'ieeg', 'cleanieeg'}
            sfreq = experiment.processing.ieeg.sample_rate;
        otherwise
            error('Unknown data_type: "%s"', data_type);
    end
end