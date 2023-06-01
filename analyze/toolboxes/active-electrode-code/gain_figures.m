
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gain_figures
%     make gain figures for all files in a directory
%
%   Uses: calcSignal.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [FsVals, meanGain, medianGain] = gain_figures(pathstr)

% process all tdms files in this directory
fileList = dir(strcat(pathstr,'/*.mat'));

meanGain = zeros(1,size(fileList,1));
medianGain = zeros(1,size(fileList,1));
FsVals = zeros(1,size(fileList,1));

% loop over all files
for i = 1:size(fileList,1)
    
    % make full filename, including path
    namestr = strcat(pathstr,'/',fileList(i).name);
    
    % load the data
    load(namestr);
    
    disp(['Filename: ' fileList(i).name])
    disp(['Fs: ' num2str(Fs)])
    
    % signal channels
    which_channels = 33:2:55;
    
    % gnd channels
    %which_channels = 34:2:56;
    data = [data(which_channels,:) ; data(129:129+11,:)];
    numRow = 12;
    numCol = 1;
    numChan = 2;
    
    % generate gain figures
    gain_working_threshold = 0.7;
    BncChannel = 2;
    headstage_gain = 10;
    discard_seconds_from_start = 20;
    discard_seconds_from_end = 10;
    FsVals(i) = Fs;
    [~, meanGain(i), medianGain(i)] = calcSignal(data, 'SIGNAL', discard_seconds_from_start, ...
        discard_seconds_from_end, numRow, numCol, numChan, Fs, 'TRUE', ...
        pathstr, fileList(i).name, headstage_gain, BncChannel, ...
        gain_working_threshold);
    
    
    
    close all
    
end

