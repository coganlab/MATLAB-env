function init_software_defn
%
%  init_software_defn
%
%

global experiment


init_software_engine;
init_software_modules;

addpath(experiment.software.mex_path);
