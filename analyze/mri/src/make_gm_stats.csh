#!/bin/csh -f

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/surf/"
cd $base

foreach hemi (lh rh)
  mris_make_surfaces -white NOWRITE -noaparc -noaseg -mgz -T1 T1_masked $SUBJ $hemi
  mris_calc -o $hemi.area.mid $hemi.area add $hemi.area.pial
  mris_calc -o $hemi.area.mid $hemi.area.mid div 2
  mris_calc -o $hemi.volume $hemi.area.mid mul $hemi.thickness
end

cd $start
