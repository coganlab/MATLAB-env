#! /usr/bin/bash
path=`pwd`
SUBJECTS_DIR=~/boxlink/CoganLab/ECoG_Recon_Full
#subject_list=$(find "$SUBJECTS_DIR" -maxdepth 1 -type d -regextype posix-extended -regex ".*/D[0-9]*$" -exec basename {} \;)
subject_list=( "D108" "D109" "D110" "D111" "D112" "D113A")
for Subject in $subject_list; do

    ### mapping BN_atlas cortex to subjects - left hemisphere
    mris_ca_label -l $SUBJECTS_DIR/$Subject/label/lh.cortex.label $Subject lh $SUBJECTS_DIR/$Subject/surf/lh.sphere.reg $SUBJECTS_DIR/lh.BN_Atlas.gcs $SUBJECTS_DIR/$Subject/label/lh.BN_Atlas.annot
    mri_label2vol --annot $SUBJECTS_DIR/$Subject/label/lh.BN_Atlas.annot --temp $SUBJECTS_DIR/$Subject/mri/brain.mgz --o $SUBJECTS_DIR/$Subject/mri/lh.BN_Atlas.mgz --subject $Subject --hemi lh --proj frac 0 1 0.1 --identity

    ### mapping BN_atlas cortex to subjects - right hemisphere
    mris_ca_label -l $SUBJECTS_DIR/$Subject/label/rh.cortex.label $Subject rh $SUBJECTS_DIR/$Subject/surf/rh.sphere.reg $SUBJECTS_DIR/rh.BN_Atlas.gcs $SUBJECTS_DIR/$Subject/label/rh.BN_Atlas.annot
    mri_label2vol --annot $SUBJECTS_DIR/$Subject/label/rh.BN_Atlas.annot --temp $SUBJECTS_DIR/$Subject/mri/brain.mgz --o $SUBJECTS_DIR/$Subject/mri/rh.BN_Atlas.mgz --subject $Subject --hemi rh --proj frac 0 1 0.1 --identity


    ### check the result in Freeview
    #freeview -f $SUBJECTS_DIR/$Subject/surf/lh.pial:annot=$SUBJECTS_DIR/$Subject/label/lh.BN_Atlas.annot
    #freeview -f $SUBJECTS_DIR/$Subject/surf/rh.pial:annot=$SUBJECTS_DIR/$Subject/label/rh.BN_Atlas.annot

    ### Parcellation Stats
    mris_anatomical_stats -mgz -cortex $SUBJECTS_DIR/$Subject/label/lh.cortex.label -f $SUBJECTS_DIR/$Subject/stats/lh.BN_Atlas.stats -b -a $SUBJECTS_DIR/$Subject/label/lh.BN_Atlas.annot -c $SUBJECTS_DIR/BN_Atlas_210_LUT.txt $Subject lh white 
    aparcstats2table -s $Subject --hemi lh --parc BN_Atlas --meas thickness --tablefile $SUBJECTS_DIR/$Subject/stats/lh.thickness.txt

    mris_anatomical_stats -mgz -cortex $SUBJECTS_DIR/$Subject/label/rh.cortex.label -f $SUBJECTS_DIR/$Subject/stats/rh.BN_Atlas.stats -b -a $SUBJECTS_DIR/$Subject/label/rh.BN_Atlas.annot -c $SUBJECTS_DIR/BN_Atlas_210_LUT.txt $Subject rh white
    aparcstats2table -s $Subject --hemi rh --parc BN_Atlas --meas thickness --tablefile $SUBJECTS_DIR/$Subject/stats/rh.thickness.txt

    ### convert to CIFTI files
    mkdir -p $SUBJECTS_DIR/$Subject/Native
    mris_convert --annot $SUBJECTS_DIR/$Subject/label/lh.BN_Atlas.annot $SUBJECTS_DIR/$Subject/surf/lh.white $SUBJECTS_DIR/$Subject/Native/$Subject.L.BN_Atlas.native.label.gii
    wb_command -set-structure $SUBJECTS_DIR/$Subject/Native/$Subject.L.BN_Atlas.native.label.gii CORTEX_LEFT
    mris_convert --annot $SUBJECTS_DIR/$Subject/label/rh.BN_Atlas.annot $SUBJECTS_DIR/$Subject/surf/rh.white $SUBJECTS_DIR/$Subject/Native/$Subject.R.BN_Atlas.native.label.gii
    wb_command -set-structure $SUBJECTS_DIR/$Subject/Native/$Subject.R.BN_Atlas.native.label.gii CORTEX_RIGHT

    mris_convert $SUBJECTS_DIR/$Subject/surf/lh.white $SUBJECTS_DIR/$Subject/Native/$Subject.L.white.native.surf.gii
    wb_command -set-structure $SUBJECTS_DIR/$Subject/Native/$Subject.L.white.native.surf.gii CORTEX_LEFT -surface-type ANATOMICAL -surface-secondary-type GRAY_WHITE
    mris_convert $SUBJECTS_DIR/$Subject/surf/rh.white $SUBJECTS_DIR/$Subject/Native/$Subject.R.white.native.surf.gii
    wb_command -set-structure $SUBJECTS_DIR/$Subject/Native/$Subject.R.white.native.surf.gii CORTEX_RIGHT -surface-type ANATOMICAL -surface-secondary-type GRAY_WHITE

    mris_convert $SUBJECTS_DIR/$Subject/surf/lh.pial $SUBJECTS_DIR/$Subject/Native/$Subject.L.pial.native.surf.gii
    wb_command -set-structure $SUBJECTS_DIR/$Subject/Native/$Subject.L.pial.native.surf.gii CORTEX_LEFT -surface-type ANATOMICAL -surface-secondary-type PIAL
    mris_convert $SUBJECTS_DIR/$Subject/surf/rh.pial $SUBJECTS_DIR/$Subject/Native/$Subject.R.pial.native.surf.gii
    wb_command -set-structure $SUBJECTS_DIR/$Subject/Native/$Subject.R.pial.native.surf.gii CORTEX_RIGHT -surface-type ANATOMICAL -surface-secondary-type PIAL

    wb_command -surface-average $SUBJECTS_DIR/$Subject/Native/$Subject.L.midthickness.native.surf.gii -surf $SUBJECTS_DIR/$Subject/Native/$Subject.L.white.native.surf.gii -surf $SUBJECTS_DIR/$Subject/Native/$Subject.L.pial.native.surf.gii
    wb_command -set-structure $SUBJECTS_DIR/$Subject/Native/$Subject.L.midthickness.native.surf.gii CORTEX_LEFT -surface-type ANATOMICAL -surface-secondary-type MIDTHICKNESS

    wb_command -surface-average $SUBJECTS_DIR/$Subject/Native/$Subject.R.midthickness.native.surf.gii -surf $SUBJECTS_DIR/$Subject/Native/$Subject.R.white.native.surf.gii -surf $SUBJECTS_DIR/$Subject/Native/$Subject.R.pial.native.surf.gii
    wb_command -set-structure $SUBJECTS_DIR/$Subject/Native/$Subject.L.midthickness.native.surf.gii CORTEX_RIGHT -surface-type ANATOMICAL -surface-secondary-type MIDTHICKNESS

    ### generate Workbench spec file
    cd $SUBJECTS_DIR/$Subject/Native
    wb_command -add-to-spec-file ./$Subject.native.wb.spec CORTEX_LEFT ./$Subject.L.white.native.surf.gii
    wb_command -add-to-spec-file ./$Subject.native.wb.spec CORTEX_LEFT ./$Subject.L.pial.native.surf.gii
    wb_command -add-to-spec-file ./$Subject.native.wb.spec CORTEX_LEFT ./$Subject.L.midthickness.native.surf.gii
    wb_command -add-to-spec-file ./$Subject.native.wb.spec CORTEX_LEFT ./$Subject.L.BN_Atlas.native.label.gii
    wb_command -add-to-spec-file ./$Subject.native.wb.spec CORTEX_RIGHT ./$Subject.R.white.native.surf.gii
    wb_command -add-to-spec-file ./$Subject.native.wb.spec CORTEX_RIGHT ./$Subject.R.pial.native.surf.gii
    wb_command -add-to-spec-file ./$Subject.native.wb.spec CORTEX_RIGHT ./$Subject.R.midthickness.native.surf.gii
    wb_command -add-to-spec-file ./$Subject.native.wb.spec CORTEX_RIGHT ./$Subject.R.BN_Atlas.native.label.gii

    ### mapping BN_atlas subcortex to subjects 
    mri_ca_label $SUBJECTS_DIR/$Subject/mri/brain.mgz $SUBJECTS_DIR/$Subject/mri/transforms/talairach.m3z $SUBJECTS_DIR/BN_Atlas_subcortex.gca $SUBJECTS_DIR/$Subject/mri/BN_Atlas_subcortex.mgz

    ### Segmentation stats
    mri_segstats --seg $SUBJECTS_DIR/$Subject/mri/BN_Atlas_subcortex.mgz --ctab $SUBJECTS_DIR/BN_Atlas_246_LUT.txt --excludeid 0 --sum $SUBJECTS_DIR/$Subject/stats/BN_Atlas_subcortex.stats

    ### convert to mgz files for left and right hemisphere, and combine them to a single brain mask    
    mrcalc $SUBJECTS_DIR/$Subject/mri/lh.BN_Atlas.mgz $SUBJECTS_DIR/$Subject/mri/rh.BN_Atlas.mgz -mult cortex_overlap.mif -datatype bit # create a mask for the overlap of the left and right hemisphere
    mrcalc $SUBJECTS_DIR/$Subject/mri/lh.BN_Atlas.mgz $SUBJECTS_DIR/$Subject/mri/rh.BN_Atlas.mgz -add $SUBJECTS_DIR/$Subject/mri/BN_Atlas_subcortex.mgz -mult sgm_overlap.mif -datatype bit # create a mask for the overlap of the subcortex and the cortex
    mrcalc $SUBJECTS_DIR/$Subject/mri/lh.BN_Atlas.mgz $SUBJECTS_DIR/$Subject/mri/rh.BN_Atlas.mgz -add 1.0 cortex_overlap.mif -sub -mult $SUBJECTS_DIR/$Subject/mri/BN_Atlas_subcortex.mgz 1.0 sgm_overlap.mif -sub -mult -add $SUBJECTS_DIR/$Subject/mri/aparc.BN_atlas+aseg.mgz # combine the cortex and subcortex to a single brain mask
done