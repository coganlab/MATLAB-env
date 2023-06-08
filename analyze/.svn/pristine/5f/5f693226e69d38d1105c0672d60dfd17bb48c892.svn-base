#!/bin/csh -f


set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/surf/"
cd $base

foreach hemi (lh rh)
  mris_sphere $hemi.inflated $hemi.sphere
  mris_jacobian $hemi.white $hemi.sphere $hemi.jacobian_white
end

cd $start
