function freesurfer_print_elec_slices(subj)


%plotMgridOnSlices(subj, struct('cntrst', get_contrast(subj), 'figvisible', 0, 'printFigs', 1));
plotMgridOnSlices(subj, struct('cntrst', get_contrast(subj),'printFigs', 1));

    function contrast = get_contrast(subj)
        switch subj
            otherwise
                contrast = .8;
        end
    end
end