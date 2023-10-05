function plot_activation_timeSeries(subj_labels, activation_values, options)
% PLOT_ELEC_DENSITY    Plots electrode density on brain average.
%   Outputs four figures:
%   1. For each voxel, how many electrodes are within thresh (mm).
%   2. For each voxel, how many subjects have at least 1 electrode within
%   thresh (mm).
%   3. Same as 1, but grid - depth heatmap
%   4. Same as 2, but grid - depth heatmat
arguments
    subj_labels 
    activation_values double
    options.cfg = plot_defaults([]);
    options.avgSubj = 'fsaverage';
    options.stype = 'inflated'; % smoothing space
    options.ptype = 'pial'; % display brain
    options.thresh = 15;
    options.tw = [-1 1.5];
    options.cLim = [0.2 1.2];
    options.frameRate double =  20 % frameRate: Frame rate of the movie (e.g. 120)
    options.movTitle char = 'patient_space_time_activation' % movTitle: Filename to be saved (e.g. 'S23_highGamma')
    options.colbarTitle string = 'z-score' % colbarTitle: Color axis label (e.g. 'z-score')
end

recondir = get_recondir();

%ptype = 'pial';
stype = options.stype;
ptype = options.ptype;
avgsubj = options.avgSubj;
thresh = options.thresh;
cLim = options.cLim;
cfg = options.cfg;

timeEpoch = linspace(options.tw(1),options.tw(2),size(activation_values,2));


%% Find unique subjects

subjs = {};
labels = {};
for s = 1:numel(subj_labels)
    label_split = strsplit(subj_labels{s}, '-');
    subjs = cat(1, subjs, label_split(1));
    labels = cat(1, labels, label_split(2));
end
subj_list = unique(subjs);

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
    
    % selecting desired channel values
    selectChannelIds = ismember(elecNames,subj_labels);
    avgCoordsSelect = avgCoords(selectChannelIds,:);
    elecNamesSelect = elecNames(selectChannelIds);
    isLeftSelect = isLeft(selectChannelIds);
    isSubduralSelect = isSubdural(selectChannelIds);

    % Grouping information across subjects

    groupAvgCoords = cat(1, groupAvgCoords, avgCoordsSelect);
    groupLabels = cat(1, groupLabels, elecNamesSelect);
    groupIsLeft = cat(1, groupIsLeft, isLeftSelect);
    groupIsSubdural = cat(1, groupIsSubdural, isSubduralSelect);
    groupSubjs = cat(1, groupSubjs, repmat(subj_list(d), numel(elecNamesSelect), 1));
    fprintf('%s %d\n', subj_list{d}, numel(elecNamesSelect));
    if isempty(cfg.subj_labels)
        if size(cfg.elec_colors,1) > 1
            color = cat(1, color, repmat(cfg.elec_colors(d,:), numel(elecNamesSelect), 1));
            color_legend = cat(1, color_legend, cfg.elec_colors(d,:));
        else
            color = cat(1, color, repmat(cfg.elec_colors, numel(elecNamesSelect), 1));
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
    smooth_fn = sprintf('rh.%s.mat', stype);
    pial_fn = sprintf('rh.%s.mat', ptype);
elseif strcmp(cfg.hemisphere, 'l')
    mask_to_show = mask_to_show & groupIsLeft;
    smooth_fn = sprintf('lh.%s.mat', stype);
    pial_fn = sprintf('lh.%s.mat', ptype);
else
    smooth_fn = sprintf('bh.%s.mat', stype);
    pial_fn = sprintf('bh.%s.mat', ptype);
end

groupLabels = groupLabels(mask_to_show);
groupIsLeft = groupIsLeft(mask_to_show);
groupIsSubdural = groupIsSubdural(mask_to_show);
groupAvgCoords = groupAvgCoords(mask_to_show,:);
activation_values = activation_values(mask_to_show,:);
color = color(mask_to_show,:);
groupSubjs = groupSubjs(mask_to_show);
if length(esize) > 1
    esize = esize(mask_to_show);
end

%% Plot the surface and elec density
cort = load_pial_data(fullfile(recondir, avgsubj, 'surf', smooth_fn));
activationV = zeros(size(cort.vert,1), size(activation_values,2));
% distV{2} = distV{1};
% distV{3} = distV{1};
% distV{4} = distV{1};
%groupSubjsProcessed = cellfun(@(a) str2double(a(2:end)), groupSubjs);
tic
if 1
    parfor v = 1:size(cort.vert, 1)
        V = cort.vert(v,:);
        dist_to_each_elec = sqrt(sum((groupAvgCoords - V).^2, 2));
        
        sigma = thresh/2.355;
        gauss_kernel = exp(-dist_to_each_elec.^2./(2*sigma^2));       
         
        activationV(v,:) = sum(gauss_kernel.*activation_values);
    end
end


toc
activationV(activationV<=cLim(1)) = 0;
%%
% tt = {
%     sprintf('# of subjs w/ 1+ elec %d mm', thresh);
%     sprintf('# of elecs %d mm', thresh);
%     sprintf('grid - depth # of subjs w/ 1+ elec %d mm', thresh);
%     sprintf('grid - depth # of elecs %d mm', thresh);
%     };
    size(activationV)
    f = figure;
cort = load_pial_data(fullfile(recondir, avgsubj, 'surf', pial_fn));
    for iTime = 1:size(activationV,2)
        reset(gcf)
        reset(gca)
        b = trisurf(cort.tri, cort.vert(:, 1), cort.vert(:, 2), cort.vert(:, 3), 'FaceVertexCData', activationV(:,iTime));
        
        if strcmp(cfg.hemisphere, 'l')
            view(270,0)
        elseif strcmp(cfg.hemisphere, 'r')
            view(90,0)
        elseif strcmp(cfg.hemisphere, 'b')
            view(180,0)
        end
        
        % alpha(cfg.alpha);
        alpha 1
        
        axis tight; axis equal;
        
            set(f, 'color', cfg.background_color);
            shading flat;
            lighting gouraud; 
            material dull;
            hide_axis(gca);        
            camlight_follow(gca);
            caxis(cLim)
            n_steps = 1000;
            c_white = 0.7;
            c_array = linspace(cLim(1),cLim(2),n_steps);
            c_step_white = find(c_array>=c_white,1);
            diff_step = n_steps-2.*c_step_white;

            cm = make_color_gradient_diff_steps([0.5 0.5 0.5;1 1 1; 1 1 0; 1 0 0], [c_step_white c_step_white diff_step]);
            colormap(cm)             
            %set_caxis_color(0,[0.5 0.5 0.5])

             
        cb = colorbar;
        ylabel(cb,options.colbarTitle)
        title([num2str(round(timeEpoch(iTime),2)) ' s'])
        M(iTime) = getframe(gcf);
        %
    end
    size(M)
%     title(tt{i});
    hold on;
    close
        vname = strcat(options.movTitle,'_',cfg.hemisphere,'_hemisphere_',stype,...
            'smooth_',ptype,'_display.avi');
        vidObj=VideoWriter(vname, 'Motion JPEG AVI');
        vidObj.Quality = 100;    
        vidObj.FrameRate = options.frameRate;
        open(vidObj);        
        writeVideo(vidObj,M);
         close(vidObj);
end