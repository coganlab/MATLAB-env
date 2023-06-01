#!/bin/csh -f

set CC_string = "127 112 147"
set PONS_string = "127 154 111"

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

mri_fill -PV ${PONS_string} -CV ${CC_string} wm.mgz filled.mgz

cd $start
