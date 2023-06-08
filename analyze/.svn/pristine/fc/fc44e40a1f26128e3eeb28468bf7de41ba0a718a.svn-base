function preprocNspike(rec, experiment)
%  preprocNspike processes nspike.dat fies into sorresponding files for
%  sorted by microdrives
%
%  preprocNspike(REC, EXPERIMENT)
%
%  REC - record number
% EXPRIMENT - experiment definition file

disp('In preprocNspike')

NSPIKE_CHANNELS = experiment.hardware.acquisition(1).num_channels_streamed;
disp(['Opening rec' rec '.nspike.dat'])
raw_fid = fopen(['rec' rec '.nspike.dat']);
format = 'short';
nMicrodrive = length(experiment.hardware.microdrive);
buf = 6e4;

% create new files
fid = zeros(1,nMicrodrive);

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
end
%channels

%for i = 1:nMicrodrive
 %   new_file_names = ['rec' rec '.' experiment.hardware.microdrive(i).name '.raw.dat'];
 %   fid(i) = fopen(new_file_names,'w');
%     tmp_channels = [experiment.hardware.microdrive(i).electrodes(:).channelid];
%    channels{i} = tmp_channels;
%end
%channels{1}

count = 1;

while(count > 0)
    startCh=1;
    [data,count] = fread(raw_fid, [NSPIKE_CHANNELS,buf], format);
    %first pass needs to be vectorised and i needs to be changed to an
    %array for multiple electrode towers
    disp(num2str(count))
    if(count > 0)
        for iMicrodrive = 1:nMicrodrive
            Towerchannels = startCh:startCh + channels{iMicrodrive} - 1;
            fwrite(fid(iMicrodrive), data(Towerchannels,:), format);
            startCh = startCh + channels{iMicrodrive};
        end
    end
end


for iMicrodrive = 1:nMicrodrive
    fid(iMicrodrive) = fclose(fid(iMicrodrive));
end

disp('Leaving preprocNspike')