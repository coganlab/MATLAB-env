
%comp = 'desktop'
comp = 'laptop';
[status,result] = dos('getmac'); % dos command to get mac address
mac = result(160:176);
%if strcmp(mac,'48-4D-7E-B3-F5-FC')
if strcmp(comp,'desktop')
    fileDir = 'H:\Box Sync\CoganLab\';
    RECONDIR = ['H:/Box Sync/EcoG_Recon'];
    addpath(genpath(['H:/Box Sync/EcoG_Recon/matlab_code/']));
elseif strcmp(comp,'laptop')
    fileDir = 'C:\Users\gcoga\Box\CoganLab\';
    RECONDIR = 'c:/Users/gcoga/Box/ECoG_Recon';
    addpath(genpath(['c:/Users/gcoga/Box/EcoG_Recon/matlab_code/']));
end
%end
global RECONDIR;
%RECONDIR = 'c:/users/gcoga/Box/ECoG_Recon';
%GoogleDriveDir = 'C:\Users\gcoga\Google Drive\';

%addpath(genpath('G:\eeglab14_1_1b\'));
addpath(genpath([fileDir 'analyze\']));
addpath(genpath([fileDir 'svn_code\']));
addpath(genpath([fileDir 'tmp\']));
addpath(genpath([fileDir 'speech\']));
addpath(genpath([fileDir 'NewCode']));
addpath(genpath([fileDir 'Scripts\']));

%addpath(genpath('C:\OpenEphysTesting\Scripts'));
addpath(genpath([fileDir 'EEG/']));
addpath(genpath([fileDir 'EEG/Scripts']));




DUKEDIR=[fileDir 'D_Data'];
%DUKEDIR=[GoogleDriveDir 'Data\Micro\'];

global DUKEDIR
    