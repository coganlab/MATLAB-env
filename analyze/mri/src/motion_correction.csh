#!/bin/csh
# motion_correction.csh
#
# motion corrects original .nii files and vol and surface coil files
# 
# Expects SUBJECTS_DIR, SUBJ, and RAW_FILES to be in environment 
# Expects $SUBJECTS_DIR/$SUBJ/mri/orig/vol.nii and 
#         $SUBJECTS_DIR/$SUBJ/mri/orig/surf.nii to exist
# 
#

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

echo $PWD

set input_args = ""
foreach file ($argv)
  set input_args = "$input_args -i orig/$file"
end
echo $input_args

# motion correction
mri_motion_correct.fsl -o avg.nii $input_args

# motion correct volume and surf coil files
flirt -in orig/vol.nii -ref orig/001.nii -out vol_motion_corrected.nii
flirt -in orig/surf.nii -ref orig/001.nii -out surf_motion_corrected.nii

mri_convert avg.nii avg.mgz

cd $start
