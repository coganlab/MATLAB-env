function tutorial_auditory(tutorial_dir)
% TUTORIAL_AUDITORY: Script that runs the Brainstorm-FieldTrip analysis pipeline.
%
% CORRESPONDING ONLINE TUTORIALS:
%     https://neuroimage.usc.edu/brainstorm/Tutorials/Auditory
%
% INPUTS: 
%     tutorial_dir: Directory where the sample_auditory.zip file has been unzipped

% @=============================================================================
% This function is part of the Brainstorm software:
% https://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2018 University of Southern California & McGill University
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPLv3
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Author: Francois Tadel, 2014-2016

% ===== FILES TO IMPORT =====
% You have to specify the folder in which the tutorial dataset is unzipped
if (nargin == 0) || isempty(tutorial_dir) || ~file_exist(tutorial_dir)
    error('The first argument must be the full path to the dataset folder.');
end
% Build the path of the files to import
AnatDir    = fullfile(tutorial_dir, 'sample_auditory', 'anatomy');
Run1File   = fullfile(tutorial_dir, 'sample_auditory', 'data', 'S01_AEF_20131218_01.ds');
Run2File   = fullfile(tutorial_dir, 'sample_auditory', 'data', 'S01_AEF_20131218_02.ds');
NoiseFile  = fullfile(tutorial_dir, 'sample_auditory', 'data', 'S01_Noise_20131218_01.ds');
% Check if the folder contains the required files
if ~file_exist(Run1File)
    error(['The folder ' tutorial_dir ' does not contain the folder from the file sample_auditory.zip.']);
end

% ===== CREATE PROTOCOL =====
% The protocol name has to be a valid folder name (no spaces, no weird characters...)
ProtocolName = 'TutorialAuditory';
% Start brainstorm without the GUI
if ~brainstorm('status')
    brainstorm nogui
end
% Delete existing protocol
gui_brainstorm('DeleteProtocol', ProtocolName);
% Create new protocol
gui_brainstorm('CreateProtocol', ProtocolName, 0, 0);
% Start a new report
bst_report('Start');


% ===== ANATOMY =====
% Subject name
SubjectName = 'Subject01';
% Process: Import FreeSurfer folder
bst_process('CallProcess', 'process_import_anatomy', [], [], ...
    'subjectname', SubjectName, ...
    'mrifile',     {AnatDir, 'FreeSurfer'}, ...
    'nvertices',   15000, ...
    'nas', [127, 213, 139], ...
    'lpa', [ 52, 113,  96], ...
    'rpa', [202, 113,  91]);

% ===== LINK CONTINUOUS FILE =====
% Process: Create link to raw files
sFilesRun1 = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
    'subjectname',  SubjectName, ...
    'datafile',     {Run1File, 'CTF'}, ...
    'channelalign', 1);
sFilesRun2 = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
    'subjectname',  SubjectName, ...
    'datafile',     {Run2File, 'CTF'}, ...
    'channelalign', 1);
sFilesNoise = bst_process('CallProcess', 'process_import_data_raw', [], [], ...
    'subjectname',  SubjectName, ...
    'datafile',     {NoiseFile, 'CTF'}, ...
    'channelalign', 0);
sFilesRaw = [sFilesRun1, sFilesRun2, sFilesNoise];

% Process: Convert to continuous (CTF): Continuous
sFilesRaw = bst_process('CallProcess', 'process_ctf_convert', sFilesRaw, [], ...
    'rectype', 2);  % Continuous

% Process: Snapshot: Sensors/MRI registration
bst_process('CallProcess', 'process_snapshot', [sFilesRun1, sFilesRun2], [], ...
    'target',   1, ...  % Sensors/MRI registration
    'modality', 1, ...  % MEG (All)
    'orient',   1, ...  % left
    'comment',  'MEG/MRI Registration');

% ===== STIMULATION TRIGGERS =====
% Process: Detect: standard_fix
bst_process('CallProcess', 'process_evt_detect_analog', [sFilesRun1, sFilesRun2], [], ...
    'eventname',   'standard_fix', ...
    'channelname', 'UADC001', ...
    'timewindow',  [], ...
    'threshold',   2, ...
    'blanking',    0.5, ...
    'highpass',    0, ...
    'lowpass',     0, ...
    'refevent',    'standard', ...
    'isfalling',   0, ...
    'ispullup',    0, ...
    'isclassify',  0);
% Process: Detect: deviant_fix
bst_process('CallProcess', 'process_evt_detect_analog', [sFilesRun1, sFilesRun2], [], ...
    'eventname',   'deviant_fix', ...
    'channelname', 'UADC001', ...
    'timewindow',  [], ...
    'threshold',   2, ...
    'blanking',    0.5, ...
    'highpass',    0, ...
    'lowpass',     0, ...
    'refevent',    'deviant', ...
    'isfalling',   0, ...
    'ispullup',    0, ...
    'isclassify',  0);

% Process: Remove simultaneous (standard)
bst_process('CallProcess', 'process_evt_remove_simult', [sFilesRun1, sFilesRun2], [], ...
    'remove', 'standard', ...
    'target', 'standard_fix', ...
    'dt',     0.05, ...
    'rename', 0);
% Process: Remove simultaneous (deviant)
bst_process('CallProcess', 'process_evt_remove_simult', [sFilesRun1, sFilesRun2], [], ...
    'remove', 'deviant', ...
    'target', 'deviant_fix', ...
    'dt',     0.05, ...
    'rename', 0);

% Process: Group by name (rename standard)
bst_process('CallProcess', 'process_evt_groupname', [sFilesRun1, sFilesRun2], [], ...
    'combine', 'standard=standard_fix', ...
    'dt',      0, ...
    'delete',  1);
% Process: Group by name (rename deviant)
bst_process('CallProcess', 'process_evt_groupname', [sFilesRun1, sFilesRun2], [], ...
    'combine', 'deviant=deviant_fix', ...
    'dt',      0, ...
    'delete',  1);


% ===== REMOVE 60/180/240 Hz =====
% Process: Sinusoid removal: 60Hz 120Hz 180Hz 300Hz
sFilesNotch = bst_process('CallProcess', 'process_notch', sFilesRaw, [], ...
    'freqlist',    [60, 120, 180], ...
    'sensortypes', 'MEG', ...
    'read_all',    0);

% Process: Power spectrum density (Welch)
sFilesPsd = bst_process('CallProcess', 'process_psd', [sFilesRaw, sFilesNotch], [], ...
    'timewindow',  [], ...
    'win_length',  4, ...
    'win_overlap', 50, ...
    'clusters',    {}, ...
    'sensortypes', 'MEG', ...
    'edit', struct(...
         'Comment',    'Power', ...
         'TimeBands',  [], ...
         'Freqs',      [], ...
         'ClusterFuncTime', 'none', ...
         'Measure',    'power', ...
         'Output',     'all', ...
         'SaveKernel', 0));

% Process: Snapshot: Frequency spectrum
bst_process('CallProcess', 'process_snapshot', sFilesPsd, [], ...
    'target',   10, ...  % Frequency spectrum
    'modality', 1, ...   % MEG (All)
    'comment',  'Power spectrum density');

% Separate the three outputs
sFilesRun1  = sFilesNotch(1);
sFilesRun2  = sFilesNotch(2);
sFilesNoise = sFilesNotch(3);


% ===== CORRECT BLINKS AND HEARTBEATS =====
% Process: Detect heartbeats
bst_process('CallProcess', 'process_evt_detect_ecg', [sFilesRun1, sFilesRun2], [], ...
    'channelname', 'ECG', ...
    'timewindow',  [], ...
    'eventname',   'cardiac');

% Process: Detect eye blinks
bst_process('CallProcess', 'process_evt_detect_eog',  [sFilesRun1, sFilesRun2], [], ...
    'channelname', 'VEOG', ...
    'timewindow',  [], ...
    'eventname',   'blink');

% Process: Remove simultaneous
bst_process('CallProcess', 'process_evt_remove_simult', [sFilesRun1, sFilesRun2], [], ...
    'remove', 'cardiac', ...
    'target', 'blink', ...
    'dt',     0.25, ...
    'rename', 0);

% Process: SSP ECG: cardiac
bst_process('CallProcess', 'process_ssp_ecg', [sFilesRun1, sFilesRun2], [], ...
    'eventname',   'cardiac', ...
    'sensortypes', 'MEG', ...
    'usessp',      0, ...
    'select',      1);

% Process: SSP EOG: blink
bst_process('CallProcess', 'process_ssp_eog', [sFilesRun1, sFilesRun2], [], ...
    'eventname',   'blink', ...
    'sensortypes', 'MEG', ...
    'usessp',      0, ...
    'select',      1);


% ===== BAD SEGMENTS AND SACCADES =====
% Process: Import from file (Run01)
bst_process('CallProcess', 'process_evt_import', sFilesRun1, [], ...
    'evtfile', {Event1File, 'BST'}, ...
    'evtname', []);
% Process: Import from file (Run02)
bst_process('CallProcess', 'process_evt_import', sFilesRun2, [], ...
    'evtfile', {Event2File, 'BST'}, ...
    'evtname', []);

% Process: SSP: saccade (Run02)
bst_process('CallProcess', 'process_ssp', sFilesRun2, [], ...
    'eventname',   'saccade', ...
    'eventtime',   [0, 0.5], ...
    'bandpass',    [1, 15], ...
    'sensortypes', 'MEG', ...
    'usessp',      1, ...
    'saveerp',     0, ...
    'method',      1);

% Mark bad channels
tree_set_channelflag(sFilesRun1.FileName, 'AddBad', 'MRT51, MLO52');
tree_set_channelflag(sFilesRun2.FileName, 'AddBad', 'MRT51, MLO52, MLO42, MLO43');

% Process: Snapshot: SSP projectors
bst_process('CallProcess', 'process_snapshot', [sFilesRun1, sFilesRun2], [], ...
    'target',  2, ...  % SSP projectors
    'comment', 'SSP projectors');


% ===== IMPORT EVENTS =====
% Process: Import MEG/EEG: Events (Run01)
sFilesEpochs1 = bst_process('CallProcess', 'process_import_data_event', sFilesRun1, [], ...
    'subjectname', SubjectName, ...
    'condition',   '', ...
    'eventname',   'standard, deviant', ...
    'timewindow',  [], ...
    'epochtime',   [-0.100, 0.500], ...
    'createcond',  0, ...
    'ignoreshort', 1, ...
    'usectfcomp',  1, ...
    'usessp',      1, ...
    'freq',        [], ...
    'baseline',    [-0.1, 0]);

% Process: Import MEG/EEG: Events (Run02)
sFilesEpochs2 = bst_process('CallProcess', 'process_import_data_event', sFilesRun2, [], ...
    'subjectname', SubjectName, ...
    'condition',   '', ...
    'eventname',   'standard, deviant', ...
    'timewindow',  [], ...
    'epochtime',   [-0.100, 0.500], ...
    'createcond',  0, ...
    'ignoreshort', 1, ...
    'usectfcomp',  1, ...
    'usessp',      1, ...
    'freq',        [], ...
    'baseline',    [-0.1, 0]);


% ===== AVERAGE RECORDINGS =====
% Process: Select file comments with tag: standard
sFilesStd1 = bst_process('CallProcess', 'process_select_tag', sFilesEpochs1, [], ...
    'tag',    'standard', ...
    'search', 2, ...
    'select', 1);  % Select only the files with the tag
sFilesStd2 = bst_process('CallProcess', 'process_select_tag', sFilesEpochs2, [], ...
    'tag',    'standard', ...
    'search', 2, ...
    'select', 1);  % Select only the files with the tag

% Process: Select file comments with tag: deviant
sFilesDev1 = bst_process('CallProcess', 'process_select_tag', sFilesEpochs1, [], ...
    'tag',    'deviant', ...
    'search', 2, ...
    'select', 1);  % Select only the files with the tag
sFilesDev2 = bst_process('CallProcess', 'process_select_tag', sFilesEpochs2, [], ...
    'tag',    'deviant', ...
    'search', 2, ...
    'select', 1);  % Select only the files with the tag

% Process: Average: By condition (subject average)
sFilesAvg = bst_process('CallProcess', 'process_average', [sFilesStd1(1:40), sFilesStd2(1:40), sFilesDev1, sFilesDev2], [], ...
    'avgtype',    6, ...  % By trial groups (subject average)
    'avg_func',   1, ...  % Arithmetic average: mean(x)
    'keepevents', 0);

% Process: Difference A-B
sFilesDiff = bst_process('CallProcess', 'process_diff_ab', sFilesAvg(1), sFilesAvg(2));

% Process: Snapshot: Recordings time series
bst_process('CallProcess', 'process_snapshot', [sFilesAvg, sFilesDiff], [], ...
    'target',   5, ...  % Recordings time series
    'modality', 1, ...  % MEG (All)
    'comment',  'Evoked response');

% Process: Snapshot: Recordings topography (contact sheet)
bst_process('CallProcess', 'process_snapshot', [sFilesAvg, sFilesDiff], [], ...
    'target',   7, ...  % Recordings topography (contact sheet)
    'modality', 1, ...  % MEG
    'contact_time',   [0, 0.350], ...
    'contact_nimage', 15, ...
    'comment',  'Evoked response');


% ===== SOURCE MODELING =====
% Process: Compute head model
bst_process('CallProcess', 'process_headmodel', [sFilesEpochs1(1), sFilesEpochs2(1)], [], ...
    'comment',      '', ...
    'sourcespace',  1, ...
    'meg',          3);  % Overlapping spheres

% Process: Compute noise covariance (Noise)
bst_process('CallProcess', 'process_noisecov', sFilesNoise, [], ...
    'baseline', [0,20], ...
    'dcoffset', 1, ...
    'identity', 0, ...
    'copycond', 1, ...
    'copysubj', 0);

% Process: Snapshot: Noise covariance
bst_process('CallProcess', 'process_snapshot', sFilesNoise, [], ...
    'target',  3, ...  % Noise covariance
    'comment', 'Noise covariance');

% Minimum norm options
MneOptions = struct(...
         'NoiseCov',      [], ...
         'InverseMethod', 'wmne', ...
         'ChannelTypes',  {{}}, ...
         'SNR',           3, ...
         'diagnoise',     0, ...
         'SourceOrient',  {{'fixed'}}, ...
         'loose',         0.2, ...
         'depth',         1, ...
         'weightexp',     0.5, ...
         'weightlimit',   10, ...
         'regnoise',      1, ...
         'magreg',        0.1, ...
         'gradreg',       0.1, ...
         'eegreg',        0.1, ...
         'ecogreg',       0.1, ...
         'seegreg',       0.1, ...
         'fMRI',          [], ...
         'fMRIthresh',    [], ...
         'fMRIoff',       0.1, ...
         'pca',           1);
% Process: Compute sources
sFilesSrc1 = bst_process('CallProcess', 'process_inverse', sFilesEpochs1, [], ...
    'comment',     '', ...
    'method',      2, ...  % dSPM
    'wmne',        MneOptions, ...
    'sensortypes', 'MEG', ...
    'output',      1);  % Kernel only: shared
% Process: Compute sources
sFilesSrc2 = bst_process('CallProcess', 'process_inverse', sFilesEpochs2, [], ...
    'comment',     '', ...
    'method',      2, ...  % dSPM
    'wmne',        MneOptions, ...
    'sensortypes', 'MEG', ...
    'output',      1);  % Kernel only: shared


% ===== AVERAGE SOURCES =====
% Process: Select file comments with tag: standard
sFilesSrcStd1 = bst_process('CallProcess', 'process_select_tag', sFilesSrc1, [], ...
    'tag',    'standard', ...
    'search', 1, ...
    'select', 1);  % Select only the files with the tag
sFilesSrcStd2 = bst_process('CallProcess', 'process_select_tag', sFilesSrc2, [], ...
    'tag',    'standard', ...
    'search', 1, ...
    'select', 1);  % Select only the files with the tag

% Process: Select file comments with tag: deviant
sFilesSrcDev1 = bst_process('CallProcess', 'process_select_tag', sFilesSrc1, [], ...
    'tag',    'deviant', ...
    'search', 1, ...
    'select', 1);  % Select only the files with the tag
sFilesSrcDev2 = bst_process('CallProcess', 'process_select_tag', sFilesSrc2, [], ...
    'tag',    'deviant', ...
    'search', 1, ...
    'select', 1);  % Select only the files with the tag

% Process: Average: By condition (subject average)
sFilesSrcAvg = bst_process('CallProcess', 'process_average', [sFilesSrcStd1(1:40), sFilesSrcStd2(1:40), sFilesSrcDev1, sFilesSrcDev2], [], ...
    'avgtype',    6, ...  % By trial groups (subject average)
    'avg_func',   1, ...  % Arithmetic average: mean(x)
    'keepevents', 0);

% Process: Difference A-B
sFilesDiff = bst_process('CallProcess', 'process_diff_ab', sFilesSrcAvg(1), sFilesSrcAvg(2));

% % Process: Snapshot: Recordings topography (contact sheet)
% bst_process('CallProcess', 'process_snapshot', [sFilesSrcAvg, sFilesDiff], [], ...
%     'target',   7, ...  % Recordings topography (contact sheet)
%     'modality', 1, ...  % MEG
%     'orient',   3, ...  % top
%     'contact_time',   [0, 0.350], ...
%     'contact_nimage', 15, ...
%     'comment',  'Evoked response');

     
% Process: Delete conditions
bst_process('CallProcess', 'process_delete', sFilesRaw, [], ...
    'target', 2);  % Delete conditions

% Save and display report
ReportFile = bst_report('Save', sFilesSrcAvg);
bst_report('Open', ReportFile);


