function preprocBlackrock(day, rec, experiment,fileTag)
%  preprocBlackrock processes raw nsx fies into flat binary files
%
%  preprocBlackrock(DAY, REC, EXPERIMENT, fileTag)
%
%  DAY - recording day (string)
%  REC - record number (string)
%  EXPERIMENT - experiment definition (struct)
%  FILETAG    - filetag (string) for blackrock file (default: .ns6)

global MONKEYDIR 

disp('In preprocBlackrock')

if nargin < 4
    if ~isfield(experiment.recording,'rawfiletype')
        fileTag = '.ns6';
    else
        fileTag = ['.' experiment.recording.rawfiletype];
    end
end

recDir = [MONKEYDIR, '/', day, '/', rec, '/'];
disp(['Opening rec' rec fileTag])
filename = [recDir 'rec' rec fileTag];
format = 'short';

f = openNSx(filename,'read','p:short','t:1:2','sec','c:1:2');
nSec = f.MetaTags.DataDurationSec;
nMin = ceil(nSec/60);

%Loop over microdrives to create files
nMicrodrive = length(experiment.hardware.microdrive);
for iMicrodrive = 1:nMicrodrive
    % create binary flat file for microdrive
    new_filename = [recDir 'rec' rec '.' experiment.hardware.microdrive(iMicrodrive).name '.raw.dat'];
    fid(iMicrodrive) = fopen(new_filename,'w');
end

%Loop over microdrives to save files
for iMicrodrive = 1:nMicrodrive 
    % find microdrive channel indices
    channelid = [experiment.hardware.microdrive(iMicrodrive).electrodes(:).channelid];
    numcontacts = unique([experiment.hardware.microdrive(iMicrodrive).electrodes(:).numContacts]);
    if numel(numcontacts)>1; error('Variable number of contacts per electrode\n processing not yet implemented\n'); end
    startchan = channelid(1); stopchan = startchan + (numel(channelid(1):channelid(end))*numcontacts)-1; % assumes that all microdrive electrodes appear as a continuous chunk in raw file
    channelstring = ['c:' num2str(startchan) ':' num2str(stopchan) ]; 
    % read and write data 1 minute at a time
  for iT = 1:nMin
   timestring = ['t:' num2str(iT-1) ':' num2str(iT) ]; 
    channel_data = openNSx(filename, 'read', 'p:short',channelstring,timestring,'min');
    fwrite(fid(iMicrodrive), channel_data.Data, format);  
  end
end
disp('Leaving preprocBlackrock')
