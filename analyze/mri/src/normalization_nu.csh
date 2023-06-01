#!/bin/csh -f

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

# NORMALIZATION I
# fancy normalization
mri_convert orig.mgz avg_norm.mnc
nu_correct -iterations 2000 -stop 0.0001 avg_norm.mnc avg_norm_nu.mnc
nu_correct -iterations 2000 -stop 0.0001 avg_norm_nu.mnc avg_norm_nu2.mnc
nu_correct -iterations 2000 -stop 0.0001 avg_norm_nu2.mnc avg_norm_nu3.mnc
nu_correct -iterations 2000 -stop 0.0001 avg_norm_nu3.mnc avg_norm_nu4.mnc
mri_convert avg_norm_nu4.mnc avg_norm_nu.nii
rm *.mnc
rm *.imp
susan avg_norm_nu.nii -1 0 3 1 0 avg_norm_nu_susan.nii
mri_convert avg_norm_nu_susan.nii.gz nu.mgz

cd $start
