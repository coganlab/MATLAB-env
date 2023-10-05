function freesurfer_preprocessing(subj)

% freesurfer_makeIniLocTxtFile(subj, 0);
% makeIniLocTxtFile(subj);
% dykstraElecPjct(subj, 0);
% remap_elec_names(subj);
if ~copy_freesurfer2recon(subj)
    return;
end

% vox2ras(subj);
ras2brainshift(subj, 0);

ras2brainshift(subj, 1);

pial2mat(subj, 'pial');
pial2mat(subj, 'inflated');
pial2mat(subj, 'sulc');

combineannot(subj);

%run_elec_location_stats(subj);
copy_freesurfer2recon_full(subj);
 %freesurfer_print_elec_slices(subj);
end