function handles = plot_elec(elec_filename, cfg)
% PLOT_ELEC    plots RAS coordinates of electrodes onto current axes
%     handles = plot_elec(elec_filename, cfg)
%     All arguments are optional
%     Type "help plot_defaults" to see cfg parameters

%% Load Defaults like electrode size, font color, etc.
recondir = get_recondir(1);

if nargin < 2
    cfg = [];
end

cfg = plot_defaults(cfg);

if ~isempty(recondir)
    root = recondir;
else
    root = '.';
end


%% Load in the labels and electrode xyz data
if nargin < 1 || isempty(elec_filename)
    [elec_fn, fpath] = uigetfile(fullfile(root, '*_RAS.txt'), 'Choose .txt file of RAS coordinates');
    if ~elec_fn
        return;
    end
    elec_fn = fullfile(fpath, elec_fn);
else
    elec_fn = elec_filename;
end
if cfg.use_brainshifted
    elec_fn = strrep(elec_fn, 'RAS', 'RAS_brainshifted');
end
fprintf('Loading: %s\n', elec_fn);

elec = parse_RAS_file(elec_fn);

unames = unique(elec.labelprefix);

%% Assign each electrode depth/grid a single color
color = zeros(numel(elec.labelprefix), 3);

if isempty(cfg.subj_labels)
    if size(cfg.elec_colors,1) > 1 % enable for distinct colors
        for u = 1:numel(elec.labelprefix)
            idx = find(strcmp(unames, elec.labelprefix{u}), 1, 'first');
            color(u,:) = cfg.elec_colors(idx,:);
        end
    else
        color = repmat(cfg.elec_colors, size(elec.xyz,1), 1);
    end
end

%% Filter out labels and coordinates based cfg.labels and cfg.hemisphere
mask_to_show = ones(size(elec.xyz, 1), 1);
mask_to_show = mask_to_show == 1;
esize = cfg.elec_size(1);

if ~isempty(cfg.subj_labels)
    [mask_to_show, color, esize] = parse_cfg_labels_idx(elec.labels, cfg);
end

if ~isempty(cfg.hemisphere)
    if strcmp(cfg.hemisphere, 'r')
        mask_to_show = mask_to_show & ~elec.isLeft;
    elseif strcmp(cfg.hemisphere, 'l')
        mask_to_show = mask_to_show & elec.isLeft;
    end
end

elec.xyz = elec.xyz(mask_to_show,:);
elec.labels = elec.labels(mask_to_show);
color = color(mask_to_show,:);
if length(esize)>1
    esize = esize(mask_to_show);
end

%% Plot the electrodes and labels
handles.elec = plot_elec_data(elec.xyz, esize, color);
handles.labels = [];
if cfg.show_labels
    handles.labels = plot_elec_labels(elec.xyz, elec.labels, cfg.font_size, cfg.font_color, cfg.label_every_n);
end

end