function valid_return = copy_freesurfer2recon(subj, skip_if_present)
global globalFsDir;
global RECONDIR;

if nargin < 2
    skip_if_present = 0;
end

valid_return = false;
if isempty(globalFsDir)
    warning('global variable globalFsDir cannot be empty');
    return;
end

if isempty(RECONDIR)
    warning('global variable RECONDIR cannot be empty');
    return;
end

to_copy = {
    'elec_recon/%s.INF'
    'elec_recon/%s.LEPTO'
    'elec_recon/%s.LEPTOVOX'
    'elec_recon/%s.PIAL'
    'elec_recon/%s.PIALVOX'
    'elec_recon/%s.electrodeNames'
    'elec_recon/%s.POSTIMPLANT'
    'elec_recon/%sPostimpLoc.txt'
    'mri/orig.mgz'
    'mri/transforms/talairach.xfm'
    'mri/brainmask.mgz'
    'mri/aparc+aseg.mgz'
    'mri/aparc.a2009s+aseg.mgz'
    'surf/lh.pial'
    'surf/rh.pial'
    'surf/lh.sphere.reg'
    'surf/rh.sphere.reg'
    'surf/lh.inflated'
    'surf/rh.inflated'
%     'surf/lh.sulc'
%     'surf/rh.sulc'
    'label/lh.BA_exvivo.annot'
    'label/lh.BA_exvivo.thresh.annot'
    'label/lh.aparc.DKTatlas.annot'
    'label/lh.aparc.a2009s.annot'
    'label/lh.aparc.annot'
    'label/rh.BA_exvivo.annot'
    'label/rh.BA_exvivo.thresh.annot'
    'label/rh.aparc.DKTatlas.annot'
    'label/rh.aparc.a2009s.annot'
    'label/rh.aparc.annot'
    };

dest_root = fullfile(RECONDIR, subj);
src_root = fullfile(globalFsDir, subj);

if ~exist(src_root, 'dir')
    warning('Src folder does not exist : %s', src_root);
    return;
end

for t = 1:numel(to_copy)
    dest = fullfile(dest_root, sprintf(to_copy{t}, subj));
    if exist(dest, 'file') && skip_if_present
        continue;
    end
    dest_folder = fileparts(dest);
    if ~exist(dest_folder, 'dir')
        mkdir(dest_folder);
    end
    
    src = fullfile(src_root, sprintf(to_copy{t}, subj));
    src_folder = fileparts(src);
    if ~exist(src_folder, 'dir')
        mkdir(src_folder);
    end
    copyfiledebug(src, dest);
    try
        copyfile(src, dest);
    catch ME
        fprintf('%s\n\n', ME.message);
        return;
    end
    
end
valid_return = true;
end