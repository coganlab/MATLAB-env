#!/bin/csh -f

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

# NORMALIZATION II
# normalize the intensity corrected volume gently to create the T1 volume
set src_vol = nu.mgz
set targ_vol = T1.mgz
set conf_tmp_vol = _conf_${src_vol}

mri_convert -i ${src_vol} -o ${conf_tmp_vol} --conform
mri_normalize -n 1 -no1d -gentle ${conf_tmp_vol} ${targ_vol} -v

# manually observe
#tkmedit -f ${targ_vol} -aux ${targ_vol}

cd $start
