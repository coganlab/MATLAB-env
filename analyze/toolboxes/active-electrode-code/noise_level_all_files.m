
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% noise_level_all_files - loops through a folder of mat files and checks
% signal levels
%     
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function noise_level_all_files(pathstr)

% process all tdms files in this directory
fileList = dir(strcat(pathstr,'/*.mat'));

% loop over all files
for i = 1:size(fileList,1)
    
    % make full filename, including path
    namestr = strcat(pathstr,'/',fileList(i).name);        
    disp(['Loading:  ' namestr  char(37)]);
    
    % work on this file
    load(namestr);
    close all;
    signal = calcSignal(data, 'NOISE', 20, 10, numRow, numCol, numChan, Fs, 'TRUE', pathstr, fileList(i).name, 10, 17, 1);
end

