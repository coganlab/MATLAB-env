#!/bin/csh -f

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base


# won't work w/out aseg, even with --noaseg flag so get around it by copying a dummy aseg.mgz
cp brain.mgz aseg.mgz
mris_volmask --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon --save_distance $SUBJ

cd $start
