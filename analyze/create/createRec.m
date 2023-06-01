function Rec = createRec(filename,day,rec,experiment)
% creates a recording specific Rec structure for analyze compatibility of
% human experiments, used by procDay
Rec.Task = experiment.software.taskcontroller;
Rec.filename = sprintf('%s/%s/%s',experiment.recording.base_path,day,filename);
Rec.type = 'Human';
Rec.Ch = experiment.hardware.acquisition(1).num_channels;
Rec.Fs = experiment.hardware.acquisition(1).samplingrate;
Rec.prenum = sprintf('%03d',rec);
