function spiff_lpfc_sc32(opt_state)
%
%  spiff_lpfc_sc32(opt_state)
%  

global MONKEYDIR MONKEYNAME TASKLIST CONTROLTASKLIST CONTROLCONDLIST MONKEYRECDIR
global GUITASKLIST PSTHTASKLIST


MONKEYNAME = 'Spiff_LPFC_SC32';
MONKEYDIR = ['/vol/sas4a/' MONKEYNAME];
% MONKEYDIR = '/mnt/raid/Spiff';
MONKEYRECDIR = '/mnt/scratch/Spiff';
TASKLIST = {'Sensors','Touch','Fixate','TouchFix','SuppReach',...
    'SuppReachFix','SuppSaccade','SuppSaccadeTouch','SuppReachSaccade',...
    'DelReach','DelReachFix','DelSaccade','DelSaccadeTouch','DelReachSaccade',...
    'MemoryReach','MemoryReachFix','MemorySaccade','MemorySaccadeTouch',...
    'MemoryReachSaccade','DelReachthenSaccade','DelSaccadethenReach','SOA',...
    'MemorySOA','RaceReach','RaceSaccade','RaceReachSaccade','EyeCalibration'...
    'ColorDiscrimination','DelJoy','DelJoyFix','DelJoySaccade'};
CONTROLTASKLIST = {'DelReach','DelReachFix','DelSaccade','DelSaccadeTouch',...
    'DelReachSaccade','MemoryReach','MemoryReachFix','MemorySaccade',...
    'MemorySaccadeTouch','MemoryReachSaccade','DelJoy','DelJoyFix','DelJoySaccade'};
GUITASKLIST = {'DelReach','DelReachFix','DelSaccade','DelSaccadeTouch',...
    'DelReachSaccade','MemoryReach','MemoryReachFix','MemorySaccade',...
    'MemorySaccadeTouch','MemoryReachSaccade','DelJoy','DelJoyFix','DelJoySaccade','SOA'};
PSTHTASKLIST= {'DelReachFix','DelSaccadeTouch','DelReachSaccade','DelReach',...
    'DelSaccade','DelSaccadethenReach','SOA','MemoryReachSaccade','MemorySaccadeTouch'};

CONTROLCONDLIST = [1:8];

if nargin ==0 || strcmp(opt_state,'on')
    disp(['Adding ' MONKEYNAME]);
    
    addpath(genpath([MONKEYDIR '/matlab/']));
    addpath(genpath([MONKEYDIR '/GUI/']));
    addpath(genpath([MONKEYDIR '/C/Behavior/mex']));
    
    a = genpath([MONKEYDIR '/matlab/proc/Labview']);
    if ~isempty(a)
        if strcmp(a(end),':') 
            a = a(1:end-1);
        end
        rmpath(a);
    end
    addpath(genpath([MONKEYDIR '/m/']));
elseif strcmp(opt_state,'off')
    disp(['Removing ' MONKEYNAME]);
    warning off;
    myrmpath(genpath([MONKEYDIR '/matlab/']));
    warning on;
    myrmpath(genpath([MONKEYDIR '/m/']));
end
