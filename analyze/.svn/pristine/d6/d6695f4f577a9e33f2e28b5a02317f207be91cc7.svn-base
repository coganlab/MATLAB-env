#!/bin/csh -f

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/"
cd $base

foreach hemi (lh rh)

  # freesurfer also uses 255 for lh and 127 for rh (unclear why)
  switch ($hemi)
    case lh:
      set hemi_num = 255
      breaksw
    case rh:
      set hemi_num = 127
      breaksw
  endsw
  echo $hemi_num

  mri_pretess mri/filled.mgz $hemi_num mri/nu.mgz mri/filled-pretess$hemi_num.mgz

  mri_tessellate mri/filled-pretess$hemi_num.mgz $hemi_num surf/$hemi.orig.nofix
  mris_extract_main_component surf/$hemi.orig.nofix surf/$hemi.orig.nofix
  mris_smooth -nw surf/$hemi.orig.nofix surf/$hemi.smoothwm.nofix
  mris_inflate -no-save-sulc surf/$hemi.smoothwm.nofix surf/$hemi.inflated.nofix
  mris_sphere -q surf/$hemi.inflated.nofix surf/$hemi.qsphere.nofix
end



foreach hemi (lh rh)
  # freesurfer requires this, because mris_* automagically identifies filenames based on $SUBJ
  cp surf/$hemi.orig.nofix surf/$hemi.orig 
  # freesurfer requires this, inexplicably
  cp surf/$hemi.inflated.nofix surf/$hemi.inflated 
end

foreach hemi (lh rh)
  mris_fix_topology -mgz -sphere qsphere.nofix -genetic $SUBJ $hemi
  mris_euler_number surf/$hemi.orig
  mris_remove_intersection surf/$hemi.orig surf/$hemi.orig
  #mris_make_surfaces -whiteonly -noaparc -noaseg -mgz -T1 mri/brain.finalsurfs $SUBJ $hemi
  mris_make_surfaces -whiteonly -noaparc -noaseg -mgz -T1 brain $SUBJ $hemi
  mris_smooth -n 3 -nw surf/$hemi.white surf/$hemi.smoothwm
  mris_inflate surf/$hemi.smoothwm surf/$hemi.inflated
  mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 surf/$hemi.inflated

end

cd $start



