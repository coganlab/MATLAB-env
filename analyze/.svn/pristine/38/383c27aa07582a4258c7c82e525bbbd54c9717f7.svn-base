#!/bin/csh -f

# REGISTRATION
#
# rotate the conformed averaged scan into the canonical postion:
#	the volume is to be turned until tkmedits ideas about coronal sagittal and transversal are sattisfied
#	on coronal sections the right hemisphere HAS to be on the left side
#	# this most likely means: but this should be the output of one the previous script
#	#	in the midsagital view, frontal is to the right, and rostral is to the left (tkmedit)
#	#	in the horizontal view, the eyes are at up, the occipital pole is at bottom
#	#	in the coronal view higher slice numbers are anterior of lower slice numbers
# 20060625:
#	the midsagital slice should be at s(128)
#	the anterior and posterior commissure have to be on the same level (see ac_pc.jpg) (h128 is a great pos for the commisures)
#	the coronal AP0 slice has to be at position c(128)
# 	the rotated volume is then resliced into the orig volume (in the following script)

set start = $PWD
set base = "$SUBJECTS_DIR/$SUBJ/mri/"
cd $base

# set the source directory...
set src_vol = conformed_rawavg.mgz
set targ_vol = ${src_vol}
set edit_string = "--noedit"
set out_reg = rotate_conf_2.dat

# creat reg file
tkregister2 --targ ${targ_vol} \
            --mov ${src_vol} \
            --s $SUBJ \
            --regheader ${edit_string} \
            --reg ${out_reg}        

# edit manually, save the registration
tkregister2 --targ ${targ_vol} \
            --mov ${src_vol} \
            --reg ${out_reg}

# perform the registration
mri_vol2vol --mov ${src_vol} \
            --targ ${src_vol} \
            --o ${targ_vol} \
            --reg ${out_reg}

# copy to orig.mgz which recon-all might use
cp ${targ_vol} orig.mgz

cd $start



