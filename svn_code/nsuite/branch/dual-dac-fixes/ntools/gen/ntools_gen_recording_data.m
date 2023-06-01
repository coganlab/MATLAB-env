% recording = ntools_gen_recording_data(recording_filename_root)
%
% processes digitalio events for a given recording and generates a recording
% data structure, containing timestamps of known events.
%
% recording_filename_root: root for recording filename, eg rec001
%
% E.g.:
% recording = ntools_gen_recording_data(recording_filename_root);
%
% examine the rec_data.events array for information on events for more
% information

function recording = ntools_gen_recording_data(recording_filename_root)

    global experiment
    
    if isempty(experiment)
        error('experiment definition file not loaded.');
    end
    if ~exist('recording_filename_root', 'var') || isempty(recording_filename_root)
        error('Missing recording_filename_root parameter');
    end
    if exist(recording_filename_root, 'file')
        % try to parse out base from actual filename
        [d f] = fileparts(recording_filename_root);
        [dd ff] = fileparts(f);
        recording_filename_root = fullfile(d, ff);
    end
        
    %/data/Spiff/080529/007/rec007.dio.txt');

    
    % copy the pertinent data from the experiment definition file
    recording.settings                = experiment.recording;
    recording.settings.channels       = experiment.channels;
    recording.settings.data_glove     = experiment.data_glove;
    recording.event                   = experiment.event;
    recording.recording_filename_root = recording_filename_root;
    recording.recording_path          = fileparts(experiment.recording.recording_path_base);


    % load digital io data
    dio_data = load([recording.recording_filename_root '.dio.txt']);

    %
    % parse out event codes for DIO and stick them in a structure
    % or "hash table" for quick lookup.
    num_events = size(recording.event,2);
    for i = 1:num_events
        if strcmp(recording.event(i).source, 'dio')
            event_lookup_table.([recording.event(i).source_port num2str(recording.event(i).source_code)]).code = i;
            recording.event(i).timestamps = [ ];
        end
    end

    % loop over each recorded digital io event, parse the text representation
    % to an integer.  then add them to the recording data structure if they're
    % meaningful to us
    %
    for dio_event_index = 1:size(dio_data,1)
        timestamp = dio_data(dio_event_index,1);
        a_value = parse_8_bits(dio_data(dio_event_index,2:9));
        b_value = parse_8_bits(dio_data(dio_event_index,10:17));
        c_value = parse_8_bits(dio_data(dio_event_index,18:25));
        d_value = parse_8_bits(dio_data(dio_event_index,26:33));

        % now check codes against lookup table for each dio port
        % if we find it, stick it in the experiment defn structure
        event_index = -1;
        if (a_value ~= 0) && (isfield(event_lookup_table, ['A' num2str(a_value)]))
            event_index = event_lookup_table.(['A' num2str(a_value)]).code;
        end
        if (event_index ~= -1)
            recording.event(event_index).timestamps = [recording.event(event_index).timestamps timestamp];
            event_index = -1;
        end

        if (b_value ~= 0) && (isfield(event_lookup_table, ['B' num2str(b_value)]))
            event_index = event_lookup_table.(['B' num2str(b_value)]).code;
        end
        if (event_index ~= -1)
            recording.event(event_index).timestamps = [recording.event(event_index).timestamps timestamp];
            event_index = -1;
        end

        if (c_value ~= 0) && (isfield(event_lookup_table, ['C' num2str(c_value)]))
            event_index = event_lookup_table.(['C' num2str(c_value)]).code;
        end
        if (event_index ~= -1)
            recording.event(event_index).timestamps = [recording.event(event_index).timestamps timestamp];
            event_index = -1;
        end

        if (d_value ~= 0) && (isfield(event_lookup_table, ['D' num2str(d_value)]))
            event_index = event_lookup_table.(['D' num2str(d_value)]).code;
        end
        if (event_index ~= -1)
            recording.event(event_index).timestamps = [recording.event(event_index).timestamps timestamp];
            event_index = -1;
        end
    end
end
