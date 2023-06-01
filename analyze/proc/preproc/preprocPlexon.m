function preprocPlexon(rec, experiment)
%  preprocPlexon processes raw.plx fies into corresponding files
%
%  preprocPlexon(REC, EXPERIMENT)
%
%  REC - record number
%  EXPERIMENT - experiment definition file

disp('In preprocPlexon')

% Laser_CHANNELS = 8;
disp(['Opening rec' rec '.plx'])
filename = ['rec' rec '.plx'];
format = experiment.hardware.acquisition.data_format;
nMicrodrive = length(experiment.hardware.microdrive);
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

startCh=1;
for iMicrodrive = 1:nMicrodrive
    if iMicrodrive == 1;
        for iChan = 1:channels{1}
            [~, ~, ~, ~, ad] = plx_ad(filename, iChan-1);
            data(iChan, :) = ad';
        end
    elseif iMicrodrive == 2;
        [~, ~, ~, ~, ad] = plx_ad(filename, 49);
        data = ad';
    elseif iMicrodrive == 3;
        [~, ~, ~, ~, ad] = plx_ad(filename, 48);
        data = ad';
    end        
    Towerchannels = startCh:startCh + channels{iMicrodrive} - 1;
    fwrite(fid(iMicrodrive), data, format);
    startCh = startCh + channels{iMicrodrive};
end


for iMicrodrive = 1:nMicrodrive
    fid(iMicrodrive) = fclose(fid(iMicrodrive));
end

disp('Leaving preprocPlexon')