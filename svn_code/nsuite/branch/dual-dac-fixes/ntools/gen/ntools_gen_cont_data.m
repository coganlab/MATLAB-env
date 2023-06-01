%  cont_data = ntools_gen_cont_data(data_type, recording)
%
%  Generate a cont_data structure from a recording data structure
%
%  NB: This should not be called directly. Instead, call
%  gen_nspike_epoch_data, gen_ieeg_epoch_data, gen_cleanieeg_epoch_data

function cont_data = ntools_gen_cont_data(data_type, recording)
    cont_data = [];

    if isempty('data_type'), data_type = 'nspike'; end

    data_file = data_file_name(data_type, recording.recording_filename_root);

    cont_data = set_sensor_info(cont_data);
    cont_data = set_coor_trans(cont_data);
    cont_data = set_noise(cont_data);
    cont_data = set_sfreq(data_type, cont_data, recording);
    cont_data = set_epochs(data_type, cont_data, recording, data_file);
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

function cont_data = set_sensor_info(cont_data)
    NUM_NSPIKE_SENSORS = 256;

    cont_data.num_sensors = NUM_NSPIKE_SENSORS; %???
    for i=1:cont_data.num_sensors
        cont_data.sensor_info(i).label = recording.settings.channels(i).name;
        cont_data.sensor_info(i).typestring = 'eeg';
        cont_data.sensor_info(i).type = 1;
        cont_data.sensor_info(i).kind = 2;
        cont_data.sensor_info(i).badchan = 0;
        cont_data.sensor_info(i).lognum = i; %% isn't this redundant?
        cont_data.sensor_info(i).loc = eye(4);
    end
end

function cont_data = set_coor_trans(cont_data)
    cont_data.coor_trans.device2head = eye(4);
    cont_data.coor_trans.mri2head = [];
end

function cont_data = set_noise(cont_data)
    cont_data.noise.num_trials = [];
    cont_data.noise.num_samples = [];
    cont_data.noise.covar = [];
end

function cont_data = set_sfreq(data_type, cont_data, recording)
    global experiment

    switch(data_type)
        case 'nspike'
            cont_data.sfreq = recording.settings.sample_rate;
        case {'ieeg', 'cleanieeg'}
            cont_data.sfreq = experiment.processing.ieeg.sample_rate;
        otherwise
            error('Unknown data_type: "%s"', data_type);
    end
end

function cont_data = set_epochs(data_type, cont_data, recording, data_file)
    NSPIKE_SAMPLING_RATE = 3e4;  %  NSpike timestamps are in Nspike system sampling rate
    ms_to_samples = cont_data.sfreq./1e3;

    num_channels = length(recording.settings.channels);

    switch(data_type)
        case 'nspike'
            load_int_fun = @ntools_nspike_load_int;
            downsample_factor = 1;
        case 'ieeg'
            load_int_fun = @ntools_ieeg_load_int;
            downsample_factor = ms_to_samples;
        case 'cleanieeg'
            load_int_fun = @ntools_clean_load_int;
            downsample_factor = ms_to_samples;
    end

    cont_data.data = load_int_fun(data_file, [], [], downsample_factor);
    
    num_samples = size(cont_data.data, 2);
    cont_data.time = linspace(0, num_samples, num_samples)/ms_to_samples;
end
