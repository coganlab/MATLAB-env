function recording = ntools_gen_recording_data_from_day_and_num(recording_day, recording_number)

    global experiment
    %/data/Spiff/080529/007/rec007.dio.txt');

    recording_path          = [experiment.recording.recording_path_base '/' recording_day '/' recording_number];

    recording_filename_root = fullfile(recording_path, ['rec' recording_number]);
    recording = ntools_gen_recording_data();
end
