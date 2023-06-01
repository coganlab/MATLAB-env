%
%
% acquire data acquisition tool main entry point


function acquire

global experiment

%ACQUIRE_PATH = '/home/bijanadmin/svn_code/acquire/trunk';
ACQUIRE_PATH = '/mnt/raid/Reggie/Acquire/acquire/trunk/';
addpath(genpath(ACQUIRE_PATH))

%
%
% select experiement definition file
software_def_file = prompt_def_file('software');
if strcmp(software_def_file,'cancelled')
    disp('cancelled by user, exiting');
    pause(1.5);
    exit;
end
run(software_def_file);

hardware_def_file = prompt_def_file('hardware');
if strcmp(hardware_def_file,'cancelled')
    disp('cancelled by user, exiting');
    pause(1.5);
    exit;
end
run(hardware_def_file);

recording_def_file = prompt_def_file('recording');
if strcmp(recording_def_file,'cancelled')
    disp('cancelled by user, exiting');
    pause(1.5);
    exit;
end
run(recording_def_file);

acquire_gui_def_file = prompt_def_file('acquire_gui');
if strcmp(recording_def_file,'cancelled')
    disp('cancelled by user, exiting');
    pause(1.5);
    exit;
end
run(acquire_gui_def_file);
%
%
% parse it and configure the software/hardware/recording/GUI
% start engine and modules
init_software_defn;
init_recording_defn;
init_hardware_defn;
init_acquire_gui_defn;

% launch main gui

Main;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function def_file = prompt_def_file(type)

if(exist(['/mnt/raid/experiment_defn_files/' type '_definition_file.m']) == 0)
    [filename, pathname] = uigetfile(['/mnt/raid/experiment_defn_files/' '*' type  '_definition_file.m'], ['Select ' type ' definition file...']);

    if isequal(filename,0) || isequal(pathname,0)
        def_file = 'cancelled';
    else
        def_file = fullfile(pathname,filename);
    end
else
    def_file = ['/mnt/raid/experiment_defn_files/' type '_definition_file.m'];
end
return
