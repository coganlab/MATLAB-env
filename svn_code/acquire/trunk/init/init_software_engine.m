function init_software_engine
%
%  init_software_engine
%
%  Initialize the data acquisition engine software

global experiment;

if(exist(experiment.software.engine.path, 'file'))
    disp(['Starting data acquisition engine ' experiment.software.engine.path]);
    system(['rxvt -title "' experiment.software.engine.terminal_title '" -e ' experiment.software.engine.path ' &']);
    pause(1);
else
    disp(['Software engine: ' experiment.software.engine.path ' does not exist']);
    exit
end
return


