


function [data, Fs, numChan, numRow, numCol, sampRate, OSR, ELECTRODE]  = load_new_data(filename)

%filename = '\\vault.seas.upenn.edu\jviventi\2010-10-12 acquisition system testing\2010_10_12_file_01.tdms';

%ELECTRODE = 'RAT';      % 196 Channel array
ELECTRODE = 'HDN';     % 360 channel array

sampRate = 100000;
numChan = 25;
numRow = 18;
numCol = 20;
OSR = 20;

Fs = sampRate / (numRow * OSR);  % Sampling Frequency

[location, name, ext, versn] = fileparts(filename);

disp([datestr(now,13) ' Begining conversion of:  '  filename])

tic
data=ReadFile(filename)';
toc

% save file as original filename_demux.mat - include relevant variables
% to be used later in processing
output_namestr = strcat(location,'\',name,'_demux.mat');

tic
save(output_namestr, 'data', 'Fs', 'numChan', 'numRow', 'numCol', 'sampRate', 'OSR', 'ELECTRODE', '-v7.3');
toc

end