function copy_freesurfer2recon_full(subj)

global globalFsDir;
global RECONDIR_FULL;

if isempty(globalFsDir)
    warning('global variable globalFsDir cannot be empty');
    return;
end

if isempty(RECONDIR_FULL)
    warning('global variable RECONDIR_FULL cannot be empty');
    return;
end

copyfile(fullfile(globalFsDir, subj), fullfile(RECONDIR_FULL, subj));