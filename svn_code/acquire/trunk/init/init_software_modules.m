function init_software_modules
%
%  init_software_modules
%
%

global experiment;

if isfield(experiment.software,'module')
    nModule = length(experiment.software.module);
    for iModule = 1:nModule
        index = findstr('(',experiment.software.module(iModule).path);
        if(isempty(index))
            tmp_path = experiment.software.module(iModule).path;
        else
            tmp_path =  experiment.software.module(iModule).path(1:index -1);
        end
        if(exist(tmp_path, 'file'))
            if(isempty(index))
                disp(['Starting data acquisition module ' experiment.software.module(iModule).path]);
                system(['rxvt -title "' experiment.software.module(iModule).terminal_title '" -e ' experiment.software.module(iModule).path ' &']);
                pause(1);
            else
                disp(['Running software module ' experiment.software.module(iModule).path]);
                eval(experiment.software.module(iModule).path);
                pause(1);
            end
        else
            disp(['Module: ' experiment.software.module(iModule).path ' does not exist']);
            exit
        end
    end
end



    return

