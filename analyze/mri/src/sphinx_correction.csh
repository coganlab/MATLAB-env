#!/bin/csh -f

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

# SPHINX CORRECTION
mri_convert -i conformed_rawavg.mgz -o conformed_rawavg.mgz --sphinx

cd $start
