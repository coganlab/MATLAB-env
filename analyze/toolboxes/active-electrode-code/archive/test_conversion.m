
%function convert_all_tdms_files(Fs, numChan, numRow, OSR)

clear all; % clear all before starting to prevent crash in readfile
clc;


% process all tdms files in this directory
% list 'em
fileList = dir('*.mat');

% loop
for i = 1:size(fileList,1)
    
    [pathstr, name, ext, versn] = fileparts(fileList(i).name);  % work on this file
    
    
    disp([datestr(now,13) ' Begining test of:  '  fileList(i).name])
    
    load(fileList(i).name)   % load file

    data2 = data;
    clear data;
    
    namestr = strcat('backup\',fileList(i).name);        % save file
    load(namestr);

    mismatch = sum(sum(data2((1-1)*14+1 : 4*14 ,:) ~= data( (1-1)*14+1 : 4*14,:))) + ...
        sum(sum(data2((5-1)*14+1 : 8*14 ,:) ~= data( (8-1)*14+1 : 11*14,:))) + ...
        sum(sum(data2((9-1)*14+1 : 11*14 ,:) ~= data( (5-1)*14+1 : 7*14,:))) + ...
        sum(sum(data2((12-1)*14+1 : 15*14 ,:) ~= data( (12-1)*14+1 : 15*14,:))) ;
        
    
    disp(['  Total samples1:  '  num2str(size(data,1)*size(data,2))])
    disp(['  Total samples2:  '  num2str(size(data2,1)*size(data2,2))])
    disp(['  Sample mismatch:  '  num2str(mismatch)])
    
    
    clear data;
    clear data2;
end


%end
