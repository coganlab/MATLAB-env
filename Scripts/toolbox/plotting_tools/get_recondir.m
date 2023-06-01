function recondir = get_recondir(silent)
% put this into your startup:
% global RECONDIR;
% RECONDIR = 'c:/Users/sf225/Box Sync/ECoG_Recon';
% change folder above to your system's recon folder.

if nargin < 1
    silent = 0;
end

global RECONDIR;
if ~exist(RECONDIR, 'dir')
    if ~silent
        error('Please set RECONDIR global variable to point to the folder containing subject recon data.');
    end
end

if ~exist(fullfile(RECONDIR, 'fsaverage'), 'dir')
    if ~silent
        warning('RECONDIR points to a valid folder on your system, but it does not appear to contain recon subject folders.');
    end
end

recondir = RECONDIR;