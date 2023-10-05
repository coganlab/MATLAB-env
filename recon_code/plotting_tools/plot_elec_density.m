function plot_elec_density(subj_list, thresh, avgsubj, cfg)
% PLOT_ELEC_DENSITY    Plots electrode density on brain average.
%   Outputs four figures:
%   1. For each voxel, how many electrodes are within thresh (mm).
%   2. For each voxel, how many subjects have at least 1 electrode within
%   thresh (mm).
%   3. Same as 1, but grid - depth heatmap
%   4. Same as 2, but grid - depth heatmat

recondir = get_recondir();

%ptype = 'pial';
ptype = 'pial';
%% Load Defaults like electrode size, font color, etc.
if nargin < 2 || isempty(thresh)
    thresh = 5;
end

if nargin < 3 || isempty(avgsubj)
    avgsubj = 'fsaverage';
end

if nargin < 4
    cfg = [];
end

cfg = plot_defaults(cfg);

%% Converts coordinates from subject's brain space to average brain space
s2avg = [];
s2avg.rmDepths = 0;
s2avg.avgsubj = avgsubj; %fsaverage
s2avg.plotEm = 0;
s2avg.use_brainshifted = cfg.use_brainshifted;

groupAvgCoords = [];
groupLabels = [];
groupIsLeft = [];
groupIsSubdural = [];
groupSubjs = {};

color = [];
color_legend = [];
for d = 1:numel(subj_list)
    [avgCoords,elecNames,isLeft, ~, ~, isSubdural] = sub2AvgBrain(subj_list{d}, s2avg);
    groupAvgCoords = cat(1, groupAvgCoords, avgCoords);
    groupLabels = cat(1, groupLabels, elecNames);
    groupIsLeft = cat(1, groupIsLeft, isLeft);
    groupIsSubdural = cat(1, groupIsSubdural, isSubdural);
    groupSubjs = cat(1, groupSubjs, repmat(subj_list(d), numel(elecNames), 1));
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
    pial_fn = sprintf('rh.%s.mat', ptype);
elseif strcmp(cfg.hemisphere, 'l')
    mask_to_show = mask_to_show & groupIsLeft;
    pial_fn = sprintf('lh.%s.mat', ptype);
else
    pial_fn = sprintf('bh.%s.mat', ptype);
end

groupLabels = groupLabels(mask_to_show);
groupIsLeft = groupIsLeft(mask_to_show);
groupIsSubdural = groupIsSubdural(mask_to_show);
groupAvgCoords = groupAvgCoords(mask_to_show,:);
color = color(mask_to_show,:);
groupSubjs = groupSubjs(mask_to_show);
if length(esize) > 1
    esize = esize(mask_to_show);
end

%% Plot the surface and elec density
cort = load_pial_data(fullfile(recondir, avgsubj, 'surf', pial_fn));
distV{1} = zeros(size(cort.vert,1), 1);
distV{2} = distV{1};
distV{3} = distV{1};
distV{4} = distV{1};
groupSubjs = cellfun(@(a) str2double(a(2:end)), groupSubjs);
tic
if 1
    for v = 1:size(cort.vert, 1)
        V = cort.vert(v,:);
        dist_to_each_elec = sqrt(sum((groupAvgCoords - V).^2, 2));
        mask = dist_to_each_elec <= thresh;
        distV{1}(v) = sum(numel(unique(groupSubjs(mask))));
        distV{2}(v) = sum(mask);
        distV{3}(v) = sum(numel(unique(groupSubjs(mask & groupIsSubdural == 1)))) - sum(numel(unique(groupSubjs(mask & groupIsSubdural == 0))));
        distV{4}(v) = sum(mask & groupIsSubdural == 1) - sum(mask & groupIsSubdural == 0);
        
    end
end

if 0
    % first find vertices that are within thresh distance of any electrode
    % this reduces calculation time in next for loop
    maskV = zeros(size(cort.vert, 1), size(groupAvgCoords, 1));
    for g = 1:size(groupAvgCoords,1)
        dist_to_each_vert = sum((cort.vert - groupAvgCoords(g,:)).^2, 2);
        maskV(:,g) = dist_to_each_vert <= thresh*thresh;
    end
    idx = find(any(maskV,2));
    for i = 1:numel(idx)
        v = idx(i);
        V = cort.vert(v,:);
        dist_to_each_elec = sum((groupAvgCoords - V).^2, 2);
        mask = dist_to_each_elec <= thresh*thresh;
        distV{1}(v) = sum(numel(unique(groupSubjs(mask))));
        distV{2}(v) = sum(mask);
        distV{3}(v) = sum(numel(unique(groupSubjs(mask & groupIsSubdural == 1)))) - sum(numel(unique(groupSubjs(mask & groupIsSubdural == 0))));
        distV{4}(v) = sum(mask & groupIsSubdural == 1) - sum(mask & groupIsSubdural == 0);
        
    end
end
toc
tt = {
    sprintf('# of subjs w/ 1+ elec %d mm', thresh);
    sprintf('# of elecs %d mm', thresh);
    sprintf('grid - depth # of subjs w/ 1+ elec %d mm', thresh);
    sprintf('grid - depth # of elecs %d mm', thresh);
    };
for i = 1:4
    f = figure;
    trisurf(cort.tri, cort.vert(:, 1), cort.vert(:, 2), cort.vert(:, 3), 'FaceVertexCData', distV{i});
    set(f, 'color', cfg.background_color);
    
    axis tight; axis equal;
     shading flat;
    lighting gouraud; material dull;
    
    % alpha(cfg.alpha);
    alpha 1
    
    hide_axis(gca);
    
    camlight_follow(gca);
    if i < 3
        cm = jet;
        cm(1,:) = [.5 .5 .5];
        colormap(cm);
    else
        ca = caxis;
        scal = (0 - ca(1)) / (ca(2)-ca(1));
        cm1 = cool(floor(scal*64));
        cm2 = autumn(64-length(cm1)-1);
        cm = [flipud(cm1); [.5 .5 .5]; flipud(cm2)];
        colormap(cm);
    end
    colorbar;
    title(tt{i});
    hold on;
end