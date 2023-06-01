#!/bin/csh -f

# ------ PARAMS -----------------------------------------------------------------

setenv SRC_DIR /Users/bijanpesaran/DTI/merlin/131211/src
setenv MRI_DEFN_FILE src/mri_defn_file.txt

source $FREESURFER_HOME/SetUpFreeSurfer.csh

unsetenv SUBJECTS_DIR
setenv SUBJECTS_DIR "/Users/bijanpesaran/DTI/merlin/131211"
setenv SUBJ Merlin

# These are the raw files we want to use, e.g. the output of a single MPRAGE
# sequence
set INPUT_FILES = (`ls ??+*_MPRAGE_*/$SUBJ+??+*_MPRAGE_Surf_Coils.nii`)
setenv VOLUME_FILE "03+Low_res_FLASH_Volume_Coil/Merlin+03+Low_res_FLASH_Volume_Coil.nii" 
setenv SURF_FILE "04+Low_res_FLASH_Surf_Coils/Merlin+04+Low_res_FLASH_Surf_Coils.nii"
mkdir -p $SUBJECTS_DIR

# we need a list of the raw files in the /mri/orig directory
set RAW_FILES = ()
foreach i (`seq 1 $#INPUT_FILES`)
  set RAW_FILES = "${RAW_FILES} 00${i}.nii"
end


# ----- SETUP ------------------------------------------------------------------

set MRI_PROC_LIST = ()
foreach line ("`cat $MRI_DEFN_FILE`")
  set cmd = `echo $line | sed '/#/d'`
  set cmd = "$cmd"
  if ("$cmd" != "") then 
    set MRI_PROC_LIST = ( $MRI_PROC_LIST:q "$cmd" )
  endif
end


# setup relevant subject directory tree like $subj/mri and convert file types 
# but nothing else
set input_args = ""
foreach file ($INPUT_FILES)
  set input_args = "$input_args -i $file"
end
echo $input_args

recon-all -s $SUBJ $input_args

# now copy the origianl nii files into $SUBJ/mri/orig
# we will use them for our own motion correction
foreach i (`seq 1 ${#INPUT_FILES[*]}`)
  cp $INPUT_FILES[$i] $SUBJECTS_DIR/$SUBJ/mri/orig/00$i.nii
end

# copy over volumen and surf coil 
cp $VOLUME_FILE $SUBJECTS_DIR/$SUBJ/mri/orig/vol.nii
cp $SURF_FILE $SUBJECTS_DIR/$SUBJ/mri/orig/surf.nii



# ------ EXECUTION ------------------------------------------------------------

#/bin/csh src/motion_correction.csh 001.mgz 002.mgz 003.mgz

cd $SUBJECTS_DIR

# read config file to read commands a la procDay
foreach cmd ($MRI_PROC_LIST:q)
  /bin/csh ${SRC_DIR}/${cmd}
  set foo = $?
  echo $foo
  if ($foo == 1) then
    exit 1
  endif
end



































# ALTERNATIVE FORMAT

# ------ autorecon1 -------------------------------------------------------------

# motion correct original files and volume and surface coil files
/bin/csh src/motion_correction.csh $RAW_FILES

# correct for coil bias
/bin/csh src/bias_correction.csh

# conform data for what freesurfer expects
/bin/csh src/conform_data.csh

# reset axes to account for sphinx position of scanning
/bin/csh src/sphinx_correction.csh

# register the data as freesurfer expects
# for manual editing, click 'SAVE REG' > replace
/bin/csh src/registration.csh

# nonuniform + susan normalization
/bin/csh src/normalization_nu.csh

# normalize so that white matter has ~110 intensity
/bin/csh src/normalization_T1.csh

# create brain mask
/bin/csh src/skull_strip.csh


# ------ autorecon2 -------------------------------------------------------------

# segment white matter
/bin/csh src/segment_wm.csh

# create filled wm volume. 
/bin/csh src/fill_wm.csh

# make surfaces
/bin/csh src/make_surf.csh


# ------ autorecon3 -------------------------------------------------------------

# make final spherical inflation and jacobian
/bin/csh src/make_sphere.csh

# cortical statistics calculation, thickness, etc
/bin/csh src/make_gm_stats.csh

# make ribboon volume (labeled gray and white matter)
/bin/csh src/make_ribbon.csh














#recon-all -autorecon3 -s $SUBJ -noaseg -notalairach -notal-check -nosurfreg -nocortparc -nocortparc3 -noparcstats -noparcstats2 -nosegstats -noaparc2aseg -nowmparc -nobalabels










#
#
#cp rh* ../surf/ # some software (but not all) expects that rh.stuff will be in $subj/surf
#
#cp rh.orig.nofix rh.orig # freesurfer requires this, because mris_* automagically identifies filenames based on $subj
#cp rh.inflated.nofix rh.inflated # freesurfer requires this, inexplicably
#
#mris_fix_topology -mgz -sphere qsphere.nofix -genetic $subj rh
#mris_euler_number rh.orig
#mris_remove_intersection rh.orig rh.orig
#mris_make_surfaces -whiteonly -noaparc -noaseg -mgz -T1 ../mri/brain.finalsurfs $subj rh
#mris_smooth -n 3 -nw rh.white rh.smoothwm
#mris_inflate rh.smoothwm rh.inflated
#mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated
#
#

# nor we're ready to rejoin recon-all flow
#recon-all -autorecon1 -s $SUBJ -notalairach -notal-check -noaseg -i mav/mri/rawavg.mgz

# Manual intervention is rquired for 

# faiiiiiiiiiiiils without human data
#recon-all -autorecon2 -s $SUBJ -openmp 6 -fill -notalairach -notal-check -noaseg -nocalabel -nocareginv -nocareg -nogcareg -nocanorm -noskull-lta -cw256


#freeview -v wm_new.mgz nu.mgz
