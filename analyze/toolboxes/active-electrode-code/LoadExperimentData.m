
function [data, Fs, numRow, numCol, numChan, OSR, filename, sampRate, ELECTRODE] = LoadExperimentData (folder_str, filename, highpassF, lowpassF)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Loads experiment data, filters and corrects bad channels
%
% folder_str - the full path to the folder the data is in
% filename - the file name for the data you want to load
%           If the filename and folder_str match a known listing, then the
%           bad electrodes will be corrected. Otherwise, this step is
%           skipped.
% highpassF - High pass filter frequency in Hz
% lowpassF - low pass filter frequency in Hz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% init to empty variable. if still empty at end of the database, quit.
fileFound = 0;


%%%%%%%% Database of known bad electrode channels %%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if  (~isempty(strfind(folder_str,'2010-05-19')))
    
    %%%%%%%%%%%%%% Electrode #4 - oldest sample
    if  (~isempty(strfind(filename,'test_41_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_40_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_39_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_38_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_37_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_36_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_35_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_34_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_33_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_32_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_31_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_30_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_29_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_28_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_27_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_26_demux.mat'))) || ...
            (~isempty(strfind(filename,'test_25_demux.mat')))
        
        % % 5/19 cat - Electrode #4 – oldest sample
        % provide an index of the dead rows and columns
        bad_col = [9 12];
        bad_row = [6];
        
        % if there is a bad single pixel that you want to remove, populate it here
        bad_single_row = [16 13 9  1  4 4  1  18 3  3  3 ];
        bad_single_col = [3  4  5  6  7 11 14 11 18 19 20];
        
        fileFound = 1;      % set flag true to indicate found file
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end


% check and see if the file name was found in the database, if not warn
% user.
if (fileFound == 0)
    disp(['  File not found in fixup list! Ask Jon to add it...']);
end

% if not empty, make complete path
filename = strcat(folder_str,'/',filename);

% load the data file
disp(['Loading: ' filename]);
load(filename)

% band pass filter
disp(['Bandpass filtering data from : ' num2str(highpassF) ' Hz to ' num2str(lowpassF) ' Hz']);
data(1:numRow*numCol,:) = EEGbandpass(data(1:numRow*numCol,:), highpassF,lowpassF, Fs);

% Display chosen
if (fileFound == 1)
    disp(['Fixing up the bad rows and columns...']);
    disp(['  Bad columns: ' num2str(bad_col)]);
    disp(['  Bad rows: ' num2str(bad_row)]);
    disp(['  Bad individual electrodes (row): ' num2str(bad_single_row)]);
    disp(['  Bad individual electrodes (col): ' num2str(bad_single_col)]);
    data(1:numRow*numCol,:) = BadChannelFix (data(1:numRow*numCol,:),  numRow, numCol, bad_row, bad_col, bad_single_row, bad_single_col);
else
    disp('Skipping bad channel fixup because file not found in listing.');
end

% negate data because of convention
disp('Negating electrode data because of neuro convention....');
data(1:numRow*numCol,:)  = -data(1:numRow*numCol,:);

% Done!
disp('Done!');






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 7/14 cat - test31 file
% bad_col = [1 2 4 5 12 17];
% bad_row = [13];
% bad_single_row = [9];
% bad_single_col = [7];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 8/19 rat - test02 file
% bad_col = [1 ];
% bad_row = [];
% bad_single_row = [8];
% bad_single_col = [7];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% % % 5/19 cat - Electrode #4 – oldest sample
% % provide an index of the dead rows and columns
% bad_col = [9 12];
% bad_row = [6];
%
% % if there is a bad single pixel that you want to remove, populate it here
% bad_single_row = [16 13 9  1  4  1  18 3];
% bad_single_col = [3  4  5  6  11 14 11 19];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % STM cardiac data
% bad_col = [6 8 9 16 17 18];
% bad_row = [];
%
% % if there is a bad single pixel that you want to remove, populate it here
% bad_single_row = [];
% bad_single_col = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%7/14 - Electrode #1
% bad_col = [10 17];
% bad_row = [];
% bad_single_row = [14 4  18 1 6 6  7  8  2  2  1  2  ];
% bad_single_col = [1  1  5  7 7 10 10 11 14 15 19 19 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 7/14 cat - electrode #2 - rat electrode
% bad_col = [10 ];
% bad_row = [];
% bad_single_row = [4 6 5 5 6 11 2 8 9 11 3 1  5  1  2  6  ];
% bad_single_col = [1 2 3 4 4 5  6 6 6 7  7 12 12 13 14 14 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 10/14 cat - electrode #1 - HDN
% bad_col = [9 10 14 ];
% bad_row = [];
% bad_single_row = [4  4  5  ];
% bad_single_col = [17 8  7  ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % 5/19 cat - Electrode #4 – oldest sample
% % provide an index of the dead rows and columns
% bad_col = [9 12];
% bad_row = [6];
%
% % if there is a bad single pixel that you want to remove, populate it here
% bad_single_row = [16 13 9  1  2 4  1  ];
% bad_single_col = [3  4  5  6  8 11 14 ];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 7/14 cat - Electrode #1 – same as 5/19??
% provide an index of the dead rows and columns
% bad_col = [10 17];
% bad_row = [ ];
%
% % if there is a bad single pixel that you want to remove, populate it here
% bad_single_row = [4  14  16  18  2  1  2  6  1  8  2  2  ];
% bad_single_col = [1  1   3   5   6  7  7  7  8  11 15 19 ];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % 7/14 cat - electrode #2 - rat electrode
% bad_col = [4 10 ];
% bad_row = [];
% bad_single_row = [4 6 5 5 6 11 2 8 9 11 3 1  5  1  2  6  ];
% bad_single_col = [1 2 3 4 4 5  6 6 6 7  7 12 12 13 14 14 ];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% % % 10/14 cat - electrode #1 - HDN
% bad_col = [9 10 14 ];
% bad_row = [];
% bad_single_row = [4  4  5  ];
% bad_single_col = [17 8  7  ];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % % 10/14 cat - electrode #2 - HDN
% bad_col = [11];
% bad_row = [];
% bad_single_row = [10 15 12 3  12];
% bad_single_col = [3  3  7  13 19];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

