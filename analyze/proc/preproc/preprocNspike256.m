function preprocNspike256(rec, experiment)
%  preprocNspike processes nspike.dat files into sorresponding files for
%  sorted by microdrives
%
%  preprocNspike(REC, EXPERIMENT)
%
%  REC - record number
% EXPRIMENT - experiment definition file

disp('In preprocNspike256')

NSPIKE_CHANNELS = experiment.hardware.acquisition(1).num_channels_streamed

disp(['Opening rec' rec '.nspike.dat'])
raw_fid = fopen(['rec' rec '.nspike.dat']);
format = 'short';
microdrives = length(experiment.hardware.microdrive);

buf = 6e4;
offset = 128;

% create new files
fid = zeros(1,2*microdrives);
channels = cell(1,2*microdrives);
for i = 1:microdrives
    new_raw_file_names = ['rec' rec '.' experiment.hardware.microdrive(i).name '.raw.dat'];
    new_nspmu_file_names = ['rec' rec '.' experiment.hardware.microdrive(i).name '.nspmu.dat'];
    fid(i) = fopen(new_raw_file_names,'w');
    tmp_channels = [experiment.hardware.microdrive(i).electrodes(:).channelid];
    channels{i} = tmp_channels;
    fid(microdrives+i) = fopen(new_nspmu_file_names,'w');
    tmp_channels = [experiment.hardware.microdrive(i).electrodes(:).channelid];
    channels{microdrives+i} = tmp_channels + offset;
end

count = 1;

while(count > 0)
    [data,count] = fread(raw_fid, [NSPIKE_CHANNELS,buf], format);
    %whos data
    %first pass needs to be vectorised and i needs to be changed to an
    %array for multiple electrode towers
    %disp(num2str(count))
    if(count > 0)
        for i = 1:length(fid)
            fwrite(fid(i), data(channels{i},:), format);
        end
    end
end


for i = 1:length(fid)
    fid(i) = fclose(fid(i));
end

disp('Leaving preprocNspike256')
