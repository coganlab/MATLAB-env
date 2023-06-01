function preprocDoubleMT(rec, experiment)
%  preprocDoubleMT processes raw.dat fies into corresponding files for
%  sorted by microdrives
%
%  preprocDoubleMT(REC, EXPERIMENT)
%
%  REC - record number
%  EXPERIMENT - experiment definition file

disp('In preprocDoubleMT')

% DoubleMT_CHANNELS = 8;
disp(['Opening rec' rec '.raw.dat'])
raw_fid = fopen(['rec' rec '.raw.dat']);
format = experiment.hardware.acquisition.data_format;
nMicrodrive = length(experiment.hardware.microdrive);
buf = 6e4;

% create new files
fid = zeros(1,nMicrodrive);

DoubleMT_CHANNELS = 0;
channels = cell(1,nMicrodrive);
for iMicrodrive = 1:nMicrodrive
    channels{iMicrodrive} = 0;
    Microdrive = experiment.hardware.microdrive(iMicrodrive);
    new_file_names = ['rec' rec '.' Microdrive.name '.raw.dat'];
    fid(iMicrodrive) = fopen(new_file_names,'w');
    nElectrode = length(Microdrive.electrodes);
    for iElectrode = 1:nElectrode
        Electrode = Microdrive.electrodes(iElectrode);
        if isfield(Electrode,'numContacts')
            numContacts = Electrode.numContacts;
        else
            disp('Update experiment definition file to include numContacts')
            numContacts = 1;
        end
      channels{iMicrodrive} = channels{iMicrodrive} + numContacts;
    end
    DoubleMT_CHANNELS = DoubleMT_CHANNELS + channels{iMicrodrive};
end
channels

count = 1;
while(count > 0)
    startCh = 1;
    [data,count] = fread(raw_fid, [DoubleMT_CHANNELS,buf], format);
    count;
    %first pass needs to be vectorised and i needs to be changed to an
    %array for multiple electrode towers
    if(count > 0)
        for iMicrodrive = 1:nMicrodrive
            MTchannels = startCh:startCh + channels{iMicrodrive} - 1;
            fwrite(fid(iMicrodrive), data(MTchannels,:), format);
            startCh = startCh + channels{iMicrodrive};
        end
    end
end


for iMicrodrive = 1:nMicrodrive
    fclose(fid(iMicrodrive));
end

disp('Leaving preprocDoubleMT')