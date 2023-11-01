function freesurfer_preprocessing(subj)

% freesurfer_makeIniLocTxtFile(subj, 0);
disp("Making initial text file")
makeIniLocTxtFile(subj);
disp("Dykstra Electrode projection")
dykstraElecPjct(subj, 0);
disp("Remapping electrode names")
remap_elec_names(subj);

if ~copy_freesurfer2recon(subj)
    return;
end

% vox2ras(subj);
disp("RAS to Brain")
ras2brainshift(subj, 0);

ras2brainshift(subj, 1);

disp("pial to mat")
pial2mat(subj, 'pial');
pial2mat(subj, 'inflated');

disp("Combining annotation")
combineannot(subj);

disp("Running electrode location stats")
run_elec_location_stats(subj);

disp("Copying freesurfer to recon full")
copy_freesurfer2recon_full(subj);
 %freesurfer_print_elec_slices(subj);
end