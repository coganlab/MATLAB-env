%
%
% nview data acquisition tool main entry point


function nview()
    DEFAULT_DEFN_PATH = '/home/nspike/nspike_defn_files/';
    %dbstop error
    %dbstop in init_exp_defn.m at 44

    patient_file = prompt_for_file(fullfile(DEFAULT_DEFN_PATH, 'patient_defn_files/patient_defn*.m'), 'Select patient definition file...');
    hw_file = prompt_for_file(fullfile(DEFAULT_DEFN_PATH, 'hw_defn_files/hw_defn*.m'), 'Select hardware definition file...');
    exp_file = prompt_for_file(fullfile(DEFAULT_DEFN_PATH, 'exp_defn_files/exp_defn*.m'), 'Select experiment definition file...');

    % start engine
    system('rxvt -title "nstream engine" -e /home/nspike/svn_code/nsuite/nstream/pkg/bin/nstream &');
    pause(1);

    % parse it and configure the hardware
    run(patient_file);
    run(hw_file);
    init_exp_defn(nstream, exp_file, patient_file, hw_file, patient_code, montage_file);

    Main();
end

function def_file = prompt_for_file(file_filter, prompt_mesg)
    [filename, pathname] = uigetfile(file_filter, prompt_mesg);

    if isequal(filename,0) || isequal(pathname,0)
        disp('cancelled by user, exiting');
        pause(1.5);
        exit;
    else
        def_file = fullfile(pathname,filename);
    end
end

