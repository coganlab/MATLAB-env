#!/bin/csh -f 

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

# SKULL STRIP
# set directories and filenames
set src_vol = nu.mgz
set brain_center_string = "-c 162 185 162"
set brain_radius = 60
set out_vol = brainmask

mri_convert -i nu.mgz -o nu_for_bet.nii
bet nu_for_bet.nii ${out_vol} -v -f 0.49 -g 0.0 -r ${brain_radius} -m ${brain_center_string}
# edit manually, save as brainmask.man.fsl_mask
fslview ${out_vol} nu_for_bet.nii ${out_vol}_mask

# note -do not use '--conform' here, it will screw up the mask-making party
mri_convert -i ${out_vol}_mask.nii.gz -o ${out_vol}_mask.mgz # --conform -cw256
mri_convert -i brainmask.man.fsl_mask.nii.gz -o brainmask.man.mgz # --conform -cw256
mri_convert -i nu.mgz -o nu.mgz #--conform  -cw256
mri_mask nu.mgz brainmask.man.mgz ${out_vol}.mgz
cp ${out_vol}.mgz brainmask.auto.mgz

# copy the selected
cp brainmask.man.mgz brainmask.mgz
cp brainmask.man.mgz brain.mgz
mri_convert -i T1.mgz -o T1c.mgz --conform 
mri_convert brainmask.mgz brainmaskc.mgz --conform --cw256
mri_mask T1.mgz brainmaskc.mgz T1_masked.mgz
#cp brainmask.fsl.mgz brain.mgz

#mri_convert -i brainmask.mgz -o brainmask.mgz --conform
#mri_convert -i brain.mgz -o brain.mgz --conform --no_scale 1 -c

# check the skull segmentation manually: 
#freeview -v $subj/mri/brainmask.auto.mgz

cd $start
