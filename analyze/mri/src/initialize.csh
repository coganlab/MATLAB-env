#!/bin/csh -f



# setup relevant subject directory tree like $subj/mri and convert file types 
# but nothing else
set input_args = ""
foreach file ($INPUT_FILES)
  set input_args = "$input_args -i $file"
end
recon-all -s $SUBJ $input_args

# now copy the origianl nii files into $SUBJ/mri/orig
# we will use them for our own motion correction
foreach i (`seq 1 $#input_files`)
  cp $input_files[$i] $SUBJECTS_DIR/$SUBJ/mri/orig/00$i.nii
end

# copy over volumen and surf coil 
cp $VOLUME_FILE $SUBJECTS_DIR/$SUBJ/mri/orig/vol.nii
cp $SURF_FILE $SUBJECTS_DIR/$SUBJ/mri/orig/surf.nii



