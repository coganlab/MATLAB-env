function archie_lpfc_sc32(opt_state)
%
%  archie_lpfc_sc32(opt_state)
%

global MONKEYDIR MONKEYNAME TASKLIST MONKEYRECDIR CONTROLTASKLIST CONTROLCONDLIST PSTHTASKLIST

%opt_state = 'on';
%warning off;
%addpath('/mnt/raid/Archie/C/NSpike/current_version/examples/mex');

MONKEYNAME = 'Archie_LPFC_SC32';
MONKEYDIR = ['/vol/sas4a/' MONKEYNAME];
MONKEYRECDIR = '/mnt/scratch/Archie';
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
CONTROLCONDLIST = [1:8];

PSTHTASKLIST= {'DelReachFix','DelSaccadeTouch','DelReachSaccade','DelReach','DelSaccade', 'MemorySaccade'};



if nargin ==0 || strcmp(opt_state,'on')
    disp(['Adding ' MONKEYNAME]);
    
    addpath(genpath([MONKEYDIR '/matlab/']));
    addpath(genpath([MONKEYDIR '/GUI/']));
    addpath(genpath([MONKEYDIR '/m/']));
    addpath(genpath([MONKEYDIR '/misc/']));

    myrmpath(genpath([MONKEYDIR '/matlab/proc/Behavior'])); 
    a = genpath([MONKEYDIR '/matlab/proc/Labview']);
    if length(a)
        if strcmp(a(end),':') 
            a = a(1:end-1);
        end
        rmpath(a);
    end
elseif strcmp(opt_state,'off')
    disp(['Removing ' MONKEYNAME]);
    warning off;
    myrmpath(genpath([MONKEYDIR '/matlab/']));
    warning on;
    myrmpath(genpath([MONKEYDIR '/m/']));
end

warning on;
