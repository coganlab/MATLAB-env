function subjs = list_recon_subjs()

global RECONDIR;

names = dir(fullfile(RECONDIR, 'D*'));

subjs = {names(:).name};
subjs = subjs';
