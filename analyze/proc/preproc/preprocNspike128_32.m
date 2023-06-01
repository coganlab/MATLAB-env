function preprocNspike32(rec, experiment)
%  preprocNspike processes nspike.dat fies into sorresponding files for
%  sorted by microdrives
%
%  preprocNspike(REC, EXPERIMENT)
%
%  REC - record number
% EXPRIMENT - experiment definition file

disp('In preprocNspike128_32')

NSPIKE_CHANNELS = 128;
disp(['Opening rec' rec '.nspike.dat'])
raw_fid = fopen(['rec' rec '.nspike.dat']);
format = 'short';
microdrives = length(experiment.hardware.microdrive);
buf = 6e4;

% create new files
fid = zeros(1,microdrives);
for i = 1:microdrives
    new_file_names = ['rec' rec '.' experiment.hardware.microdrive(i).name '.raw.dat'];
    fid(i) = fopen(new_file_names,'w');
    tmp_channels = [experiment.hardware.microdrive(i).electrodes(:).channelid];
    channels{i} = tmp_channels;
end
channels{1} = [1:8,17:24,33:40,49:56];

count = 1;

while(count > 0)
    [data,count] = fread(raw_fid, [NSPIKE_CHANNELS,buf], format);
    %first pass needs to be vectorised and i needs to be changed to an
    %array for multiple electrode towers
%disp(num2str(count))
    if(count > 0)
        for i = 1:microdrives
            fwrite(fid(i), data(channels{i},:), format);
        end
    end
end


for i = 1:microdrives
    fid(i) = fclose(fid(i));
end

disp('Leaving preprocNspike128_32')