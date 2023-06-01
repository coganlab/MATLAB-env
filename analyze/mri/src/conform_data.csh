#!/bin/csh -f

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

# CONFORM DATA
# create the faked conformed data file, if copy is not enough, use mri_convert with -iis -ijs -iks flags
# this fakes out freesurfer into thinking that we have 1 mm voxel dimensions, instead of 0.5mm, which is
# internally required for whatever reason
mri_convert -i avg_norm.mgz -o conformed_rawavg.mgz -iis 1 -ijs 1 -iks 1

# SIZE CONFORMING
# make sure the input volume is 256 by 256 by 256 voxels in size
# the voxel dimenswions are already tweaked to 1mm isotropic, now enforce 256 x 256 x 256 voxels
mri_convert -i conformed_rawavg.mgz -o conformed_rawavg.mgz --conform --no_scale 1 -nc

cd $start
