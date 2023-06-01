
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convert_all_tdms_files - converts all the tdms files in this folder from
%     tdms files into .mat file. Also does demultiplexing and column
%     re-ordering
%
%   Before using, setup definitions below!
%
% The new fields are:
% ELECTRODE - which type of electrode was used.
% Fs - the effective sampling rate
% OSR - the oversampling rate
% numChan - the number of analog channels recorded, including the trigger channel(s)
% numCol - the number of electrode array columns
% numRow - the number of electrode array rows
% sampRate - the raw sampling rate of the A2D converters, in Hz.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fix_all_mat_demux_files(pathstr,ELECTRODE)

%clear all; % clear all before starting to prevent crash in readfile
clc;

% define which electrode data we are working on
%ELECTRODE = 'RAT';      % 196 Channel array
%ELECTRODE = 'HDN';     % 360 channel array

% Electrode data definition

% 196 Channel Rat Array
if strcmp( ELECTRODE, 'RAT')
    sampRate = 125000;
    numChan = 15;
    numRow = 14;
    numCol = 14;
    OSR = 30;
    
    % column look up table used to re-order the analog channels to get them
    % into the correct physical order
    %         1  2  3  4  5  6  7  8  9  10 11 12 13 14 15
    colLut = [1  2  3  4  8  9  10 11 5  6  7  12 13 14 15];
end

% 360 Channel HDN Array
if strcmp( ELECTRODE, 'HDN')
    sampRate = 100000;
    numChan = 25;
    numRow = 18;
    numCol = 20;
    OSR = 20;
    
    % column look up table used to re-order the analog channels to get them
    % into the correct physical order
    %         1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
    colLut = [1  2  3  4  5  11 12 13 14 6  7  8  9  10 16 17 18 19 15 20 21 22 23 24 25];
end

% Calculate effective sampling rate
Fs = sampRate / (numRow * OSR);  % Sampling Frequency

% process all tdms files in this directory
fileList = dir(strcat(pathstr,'\*.mat'));

% create a cell table of the files and OSR data
% column 1 - file names
fileData = cellstr(strvcat(fileList.name));

% column 2 - OSR
fileData(:,2) = num2cell(ones(size(fileList)) * OSR);

% pause to allow data file exception editing
disp('Pausing to allow entry of OSR data. Please edit fileData, if needed')
keyboard

% loop over all files
for i = 1:size(fileList,1)
    
    % make full filename, including path
    namestr = strcat(pathstr,'\',fileList(i).name);        
    
    % work on this file
    [location, name, ext, versn] = fileparts(namestr);
    
    % set OSR for this file
    OSR = cell2mat(fileData(i,2));
    
    
    disp([datestr(now,13) ' Begining fixup of:  '  namestr])
    disp([datestr(now,13) '  OSR= ' num2str(OSR)])
    
    load(namestr)   % load file
    
    % Reshape to 3d array
    g = reshape(data,numRow,numChan,size(data,2));
    
    % re-arrange arrays based on above look up tables
    g = g(:,colLut,:);
    
    % reshape back to 2d for convienience sake
    data = reshape(g,numRow*numChan,size(data,2));
    
    
    % save file as original filename_demux.mat - include relevant variables
    % to be used later in processing
    output_namestr = strcat(pathstr,'\',name,'.mat');
    save(output_namestr, 'data', 'Fs', 'numChan', 'numRow', 'numCol', 'sampRate', 'OSR', 'ELECTRODE', '-v7.3');
    
    clear data;
end

end

