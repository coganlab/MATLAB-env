function handles = plot_subj(subj, cfg)
recondir = get_recondir();
if nargin < 2
    cfg = [];
end
cfg = plot_defaults(cfg);

%% Plot pial
handles.surf = plot_surf(fullfile(recondir, subj, 'surf', sprintf('%sh.pial.mat', cfg.hemisphere)), cfg);

%% Plot elec and labels
h = plot_elec(fullfile(recondir, subj, 'elec_recon', sprintf('%s_elec_locations_RAS.txt', subj)), cfg);
handles.elec = h.elec;
handles.labels = h.labels;

%% Plot annotation (cortex ROIs)
if cfg.show_annot
    if cfg.hemisphere == 'b'
        plot_annotation([], fullfile(recondir, subj, 'label', sprintf('%sh.aparc.annot.mat', cfg.hemisphere)));
    else
        plot_annotation([], fullfile(recondir, subj, 'label', sprintf('%sh.aparc.annot', cfg.hemisphere)));
    end
end
end