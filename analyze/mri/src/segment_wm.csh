#!/bin/csh -f

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base


set controlpoints = ../tmp/control.dat
set unmasked_brain = brain.unmasked.mgz
set brain = brain.mgz
set mask = brainmask.mgz
set final = brain.finalsurfs.mgz
set wlo = 85
set ghi = 130
set border_class_it = 2

cp brainmask.auto.mgz brainmask.auto.mgz.bak
cp brainmask.mgz brainmask.auto.mgz

#mri_convert -i brain.mgz -o brainc.mgz --conform
# segment the white matter
mri_normalize -monkey -MASK brainmaskc.mgz T1_masked.mgz renormbrain.mgz
#mri_normalize -monkey -mask brainmask.mgz nu.mgz renormbrain.mgz
#mri_segment -v -fillv -fillbg -wlo $wlo -ghi $ghi -n $border_class_it T1_masked.mgz wm.seg.mgz
mri_segment -v -fillv -fillbg -wlo 90 -ghi 95 -n $border_class_it renormbrain3.mgz wm2.seg.mgz
#mri_segment -v -fillv -fillbg -wlo $wlo -ghi $ghi -n $border_class_it renormbrain.mgz wm.seg.mgz

# you'll want to check the white matter reconstruction wm.mgz. Re-save it as wmnew when you're satisfied
freeview -v wm.seg.mgz renormbrain.mgz


# then check w/ pretess
#mri_pretess wm.seg.mgz wm nu.mgz wm.mgz
mri_pretess wm2.seg.mgz wm T1_masked.mgz wm.mgz

#freeview -v wm.mgz nu.mgz

#
#mri_convert brain.mgz brain.nii
#susan brain.nii -1 0 3 1 0 brainsusan.nii
#mri_convert brainsusan.nii.gz brainsusan.mgz --conform
#tkmedit -f brainsusan.mgz
#mri_normalize -f mav/mri/tmp/control.dat -MASK brainmask.mgz -monkey T1.mgz renormbrain.mgz
#tkmedit -f renormbrain.mgz
#mri_segment -v -fillv -fillbg -wlo 95  -ghi 96 -n $border_class_it renormbrain.mgz wm.mgz
#freeview -v wm.mgz
#
cd $start
