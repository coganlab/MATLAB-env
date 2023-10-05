function handles = plot_subjs_on_average(subj_list, avgsubj, cfg)
% PLOT_ELEC_ON_AVERAGE    Plots multiple subject electrodes on a single
%   average brain.
%   handles = plot_elec_on_average(subj_list, avgsubj, cfg)
%   subj_list is required, e.g. {'D14', 'D15', 'D16'}
%   Type "help load_plot_defaults" to see cfg parameters

recondir = get_recondir();

%% Load Defaults like electrode size, font color, etc.
if nargin < 3
    cfg = [];
end

if nargin < 2 || isempty(avgsubj)
    avgsubj = 'fsaverage';
end

cfg = plot_defaults(cfg);

%% Converts coordinates from subject's brain space to average brain space
s2avg = [];
s2avg.rmDepths = 0;
s2avg.avgsubj = avgsubj; %fsaverage
s2avg.plotEm = 0;

groupAvgCoords = [];
groupLabels = [];
groupIsLeft = [];

color = [];
color_legend = [];
for d = 1:numel(subj_list)
    [avgCoords,elecNames,isLeft] = sub2AvgBrain(subj_list{d}, s2avg);
    groupAvgCoords = cat(1, groupAvgCoords, avgCoords);
    groupLabels = cat(1, groupLabels, elecNames);
    groupIsLeft = cat(1, groupIsLeft, isLeft);
    fprintf('%s %d\n', subj_list{d}, numel(elecNames));
    if isempty(cfg.subj_labels)
        if size(cfg.elec_colors,1) > 1
            color = cat(1, color, repmat(cfg.elec_colors(d,:), numel(elecNames), 1));
            color_legend = cat(1, color_legend, cfg.elec_colors(d,:));
        else
            color = cat(1, color, repmat(cfg.elec_colors, numel(elecNames), 1));
            color_legend = cat(1, color_legend, cfg.elec_colors);
        end
    end
end

%% Filter out labels and coordinates based on cfg.labels and cfg.hemisphere
mask_to_show = ones(size(groupAvgCoords, 1), 1);
mask_to_show = mask_to_show == 1;
esize = cfg.elec_size(1);

if ~isempty(cfg.subj_labels)
    [mask_to_show, color, esize] = parse_cfg_labels_idx(groupLabels, cfg);
    color_legend = cfg.elec_colors;
    labels_legend = arrayfun(@(a) sprintf('%d', a), 1:size(color_legend, 1), 'un', 0);
else
    labels_legend = subj_list;
end

if strcmp(cfg.hemisphere, 'r')
    mask_to_show = mask_to_show & ~groupIsLeft;
    pial_fn = 'rh.pial.mat';
elseif strcmp(cfg.hemisphere, 'l')
    mask_to_show = mask_to_show & groupIsLeft;
    pial_fn = 'lh.pial.mat';
else
    pial_fn = 'bh.pial.mat';
end

groupLabels = groupLabels(mask_to_show);
groupAvgCoords = groupAvgCoords(mask_to_show,:);
color = color(mask_to_show,:);
if length(esize) > 1
    esize = esize(mask_to_show);
end
    
%% Plot the surface, electrodes, and labels, and return all handles
handles.surf = plot_surf(fullfile(recondir, avgsubj, 'surf', pial_fn), cfg);
handles.elec = plot_elec_data(groupAvgCoords, esize, color);
if cfg.show_labels
    handles.labels = plot_elec_labels(groupAvgCoords, groupLabels, cfg.font_size, cfg.font_color, cfg.label_every_n);
end

%legendf(labels_legend, color_legend);
end