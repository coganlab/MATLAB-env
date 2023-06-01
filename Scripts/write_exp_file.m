function write_exp_file(subject,subjdate,header,chans)
% beta, but writes experiment file for a subject using NY351 as a template
% (so clinical)
% write_exp_file(subject,subjdate,header,chans)
% subject = subject name, string
% subjdate= data of data acquisition, string
% header = header file from edf (use readedf3 to get this)
%chans= number of channels to write
% If 2 dates, try and collapse into 1
duke;
load([DUKEDIR '\experiment_template.mat']); % loads a template file
experiment.recording.nspike_num_channels_to_write_low=chans; % change this to equal number of data channels!
experiment.recording.nspike.sample_rate=2000;
experiment.processing.ieeg.sample_rate=2000;
experiment.processing.ieeg.lowpass=1000;
experiment.processing.ieeg.sample_rate=2000;
experiment.recording.sample_rate=2000;
if size(experiment.channels,2)>experiment.recording.nspike_num_channels_to_write_low
    for iC=1:(size(experiment.channels,2)-experiment.recording.nspike_num_channels_to_write_low)
        experiment.channels(chans+1)=[];
    end
end
    
experiment.recording.recording_day=subjdate; % date should be in YYMMDD format

for iChan=1:experiment.recording.nspike_num_channels_to_write_low;
%    experiment.channels(iChan).name=header.channelname(iChan,:);
     experiment.channels(iChan).name=header.label{iChan};

    experiment.channels(iChan).lowpass_cutoff=1000;
end

if ~exist([DUKEDIR '/' subject],'dir')
    mkdir([DUKEDIR '/' subject]);
end
    
if ~exist([DUKEDIR '/' subject '/mat'],'dir')
    mkdir([DUKEDIR '/' subject '/mat']);
end

save([DUKEDIR '/' subject '/mat/experiment.mat'],'experiment');