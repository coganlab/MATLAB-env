#!/bin/csh -f



set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

fslmaths vol_motion_corrected.nii.gz -kernel gauss 10 -fmean vol_smooth.nii
fslmaths surf_motion_corrected.nii.gz -kernel gauss 10 -fmean surf_smooth.nii
fslmaths vol_smooth.nii.gz -div surf_smooth.nii.gz biasfield.nii
fslmaths avg.nii -mul biasfield.nii.gz avg_norm.nii
mri_convert avg_norm.nii.gz avg_norm.mgz

cd $start

