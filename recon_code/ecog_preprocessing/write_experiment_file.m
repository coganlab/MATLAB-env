
if ~exist('d', 'var')
    [~,d] = edfread_fast(edf_filename);
end
h = edfread_fast(edf_filename);
h.label'

d = d(neural_chan_index,:);
labels = h.label(neural_chan_index);

fid = fopen(sprintf('%s%s.ieeg.dat', ieeg_prefix, taskdate), 'w');
fwrite(fid, d, 'float');
fclose(fid);



load experiment_template.mat;
experiment.recording.sample_rate = round(h.frequency(1));
experiment.recording.recording_day = taskdate;
experiment.recording.nspike_num_channels_to_write_low=numel(labels); % change this to equal number of data channels!
experiment.recording.nspike.sample_rate=round(h.frequency(1));
experiment.processing.ieeg.sample_rate=round(h.frequency(1));
experiment.processing.ieeg.lowpass=1000;
experiment.processing.ieeg.sample_rate=round(h.frequency(1));

experiment.recording.recording_day=taskdate; % date should be in YYMMDD format
experiment.channels = [];
for iChan=1:numel(labels)
    experiment.channels(iChan).name=labels{iChan};
    experiment.channels(iChan).lowpass_cutoff=1000;
    experiment.channels(iChan).highpass_cutoff=1;
end

save('experiment.mat', 'experiment');


mkdir(taskdate);
mkdir('mat');
mkdir(fullfile(taskdate, rec));
mkdir(fullfile(taskdate, 'mat'));
