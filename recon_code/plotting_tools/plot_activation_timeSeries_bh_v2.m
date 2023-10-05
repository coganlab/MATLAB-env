function plot_activation_timeSeries_bh_v2(subj_labels, activation_values, options)
% PLOT_ACTIVATION_DENSITY Plots electrode density on brain average.
%
%   Plots the electrode density on the average brain surface for each
%   hemisphere. Outputs four sublplots in a figure:
%
%   1. For each voxel, shows the number of electrodes within a given
%      threshold (mm).
%   2. For each voxel, shows the number of subjects that have at least
%      one electrode within the specified threshold (mm).
%   3. Similar to 1, but as a grid-depth heatmap.
%   4. Similar to 2, but as a grid-depth heatmap.
%
% Inputs:
%   - subj_labels: Cell array of electrode labels for each subject.
%   - activation_values: Matrix of activation values for electrodes.
%   - options: Structure containing various configuration options.
%
% Configuration Options:
%   - cfg: Configuration structure for plotting.
%   - avgSubj: Average subject name (e.g., 'fsaverage').
%   - stype: Smoothing space ('inflated', 'white', etc.).
%   - ptype: Display brain type ('pial', 'inflated', etc.).
%   - thresh: Threshold in millimeters.
%   - cLim: Color axis limits.
%   - colbarTitle: Color axis label (default: 'z-score').
%   - colorSteps: Number of color steps in the colormap.
%   - transparentPoint: Transparency level for the lowest activation values.
%
% Example usage:
%   plot_activation_density(subj_labels, activation_values, options);


arguments
    subj_labels 
    activation_values double
    options.cfg = plot_defaults([]);
    options.avgSubj = 'fsaverage';
    options.stype = 'inflated'; % smoothing space
    options.ptype = 'pial'; % display brain
    options.thresh = 15;    
    options.cLim = [0 1];
    options.colbarTitle string = 'z-score' % colbarTitle: Color axis label (e.g. 'z-score')
    options.colorSteps = 1000;
    options.transparentPoint = 0.025;
    options.colorscale = 'parula'
    options.tw = [-1 1.5];
    options.frameRate double =  20 % frameRate: Frame rate of the movie (e.g. 120)
    options.movTitle char = 'patient_space_time_activation' % movTitle: Filename to be saved (e.g. 'S23_highGamma')
    options.elecDensityThresh = 1;
    options.showMesial = 0;
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


mask_to_show_rh = mask_to_show & ~groupIsLeft;
smooth_fn_rh = sprintf('rh.%s.mat', stype);
pial_fn_rh = sprintf('rh.%s.mat', ptype);

mask_to_show_lh = mask_to_show & groupIsLeft;
smooth_fn_lh = sprintf('lh.%s.mat', stype);
pial_fn_lh = sprintf('lh.%s.mat', ptype);



groupAvgCoords_lh = groupAvgCoords(mask_to_show_lh,:);
activation_values_lh = activation_values(mask_to_show_lh,:);

groupAvgCoords_rh = groupAvgCoords(mask_to_show_rh,:);
activation_values_rh = activation_values(mask_to_show_rh,:);

%% Plot the surface, curvature, and activation of left hemisphere
cort_lh = load_pial_data(fullfile(recondir, avgsubj, 'surf', smooth_fn_lh));
activationV_lh = zeros(size(cort_lh.vert,1), size(activation_values_lh,2));
curv = read_curv(fullfile(recondir, avgsubj, 'surf','lh.curv'));

if strcmpi(ptype,'inflated')
    overlayDataTemp=zeros(length(curv),3);
    pcurvIds=find(curv>=0);
    overlayDataTemp(pcurvIds,:)=repmat([1 1 1]*.4,length(pcurvIds),1);
    ncurvIds=find(curv<0);
    overlayDataTemp(ncurvIds,:)=repmat([1 1 1]*.6,length(ncurvIds),1);
else
    overlayDataTemp=ones(length(curv),3)*.6;
end

tic
if 1
    for iElec = 1:size(groupAvgCoords_lh,1)
        
        elecCoord = groupAvgCoords_lh(iElec,:);
        dist_to_each_vert = sqrt(sum((elecCoord -  cort_lh.vert).^2, 2));
        sigma = thresh/2.355;
        gauss_temp =  exp(-dist_to_each_vert.^2./(2*sigma^2));
        gauss_temp_dia = gauss_temp(find(dist_to_each_vert>=1.1,1));
        gauss_temp = gauss_temp+gauss_temp_dia;        
        gauss_temp(gauss_temp>1) = 1;
        gauss_kernel(:,iElec) = gauss_temp;        
    end
    
end
gauss_kernel_sum = sum(gauss_kernel,2);
kernValid = gauss_kernel_sum>=options.elecDensityThresh;
activationV_lh(kernValid,:) = gauss_kernel(kernValid,:)*activation_values_lh./gauss_kernel_sum(kernValid);

toc
overlayData_time_lh = [];
parfor iTime = 1:size(activationV_lh,2)
    olayDataVec=activationV_lh(:,iTime);
    [overlayData_lh, oLayLimits, olayCmapName]=vals2Colormap(olayDataVec,cLim ,options.colorscale);
    maskIds=find(abs(olayDataVec)<=options.transparentPoint);
    overlayData_lh(maskIds,:)=overlayDataTemp(maskIds,:);
    overlayData_time_lh(iTime,:,:) = overlayData_lh;
end
%% Plot the surface and elec density of right hemisphere
cort_rh = load_pial_data(fullfile(recondir, avgsubj, 'surf', smooth_fn_rh));
activationV_rh = zeros(size(cort_rh.vert,1), size(activation_values_rh,2));
curv = read_curv(fullfile(recondir, avgsubj, 'surf','rh.curv'));

if strcmpi(ptype,'inflated')
    overlayDataTemp=zeros(length(curv),3);
    pcurvIds=find(curv>=0);
    overlayDataTemp(pcurvIds,:)=repmat([1 1 1]*.4,length(pcurvIds),1);
    ncurvIds=find(curv<0);
    overlayDataTemp(ncurvIds,:)=repmat([1 1 1]*.6,length(ncurvIds),1);
else
    overlayDataTemp=ones(length(curv),3)*.6;
end

tic
if 1
    gauss_kernel = [];
    for iElec = 1:size(groupAvgCoords_rh,1)
        
        elecCoord = groupAvgCoords_rh(iElec,:);
        dist_to_each_vert = sqrt(sum((elecCoord -  cort_rh.vert).^2, 2));
        sigma = thresh/2.355;
        gauss_temp =  exp(-dist_to_each_vert.^2./(2*sigma^2));
        gauss_temp_dia = gauss_temp(find(dist_to_each_vert>=1.1,1));
        gauss_temp = gauss_temp+gauss_temp_dia;        
        gauss_temp(gauss_temp>1) = 1;
        gauss_kernel(:,iElec) = gauss_temp;        
    end
end
gauss_kernel_sum = sum(gauss_kernel,2);
kernValid = gauss_kernel_sum>=options.elecDensityThresh;
activationV_rh(kernValid,:) = gauss_kernel(kernValid,:)*activation_values_rh./gauss_kernel_sum(kernValid);

toc
overlayData_time_rh = [];
parfor iTime = 1:size(activationV_rh,2)
    olayDataVec=activationV_rh(:,iTime);
    [overlayData_rh, oLayLimits, olayCmapName]=vals2Colormap(olayDataVec,cLim ,options.colorscale);
    maskIds=find(abs(olayDataVec)<options.transparentPoint);
    overlayData_rh(maskIds,:)=overlayDataTemp(maskIds,:);
    overlayData_time_rh(iTime,:,:) = overlayData_rh;
end
[~, oLayLimits, olayCmapName]=vals2Colormap(activationV_rh(:,1),cLim ,options.colorscale);
    
%% Plot the brain maps
    
    scrsize = get(0, 'Screensize');
    f = figure('Position', [scrsize(1) scrsize(2) scrsize(3)/2 scrsize(4)/2]);
    cort_lh = load_pial_data(fullfile(recondir, avgsubj, 'surf', pial_fn_lh));
    cort_rh = load_pial_data(fullfile(recondir, avgsubj, 'surf', pial_fn_rh));
%     n_steps = options.colorSteps;
%     c_white = options.transparentPoint;
%     c_array = linspace(cLim(1),cLim(2),n_steps);
%     c_step_white = find(c_array>=c_white,1);
%     diff_step = n_steps-2.*c_step_white;
%     cm = make_color_gradient_diff_steps([0.5 0.5 0.5;1 1 1; 1 1 0; 1 0 0], [c_step_white c_step_white diff_step]);
%     
    
   for iTime = 1:size(activationV_rh,2)
        if (options.showMesial)   
                clf('reset')
                h1 = subplot(2,2,1); % left hemisphere lateral
                tripatchDG(cort_lh,h1,overlayData_lh(iTime,:,:));        
                view(270,0)
                set(h1, 'color', cfg.background_color);
                alpha 1            
                axis tight; axis equal;        
                shading flat;
                lighting gouraud; 
                material dull;
                hide_axis(gca);        
                camlight_follow(gca);
        
                h2 = subplot(2,2,3);% left hemisphere medial
                tripatchDG(cort_lh,h2,overlayData_lh(iTime,:,:));
                alpha 1
                set(h2, 'color', cfg.background_color);
                axis tight; axis equal;
                view(90,0)      
                shading flat;
                lighting gouraud; 
                material dull;
                hide_axis(gca);        
                camlight_follow(gca);
        
        
                h3 = subplot(2,2,2); % right hemisphere lateral
                tripatchDG(cort_rh,h3,overlayData_rh(iTime,:,:));
                view(90,0)        
                alpha 1
                set(h3, 'color', cfg.background_color);
                axis tight; axis equal;
                shading flat;
                lighting gouraud; 
                material dull;
                hide_axis(gca);        
                camlight_follow(gca);
        
                h4 = subplot(2,2,4);% right hemisphere medial
                tripatchDG(cort_rh,h4,overlayData_rh(iTime,:,:));        
                alpha 1            
                axis tight; axis equal;
                view(270,0)                
                set(h4, 'color', cfg.background_color);
                shading flat;
                lighting gouraud; 
                material dull;
                hide_axis(gca);        
                camlight_follow(gca);
                pos=[0.1 0.08 0.8150 0.0310];
                hcbar = cbarDGplus(pos,[oLayLimits(1) oLayLimits(2)],olayCmapName,5,[],'top',15);
                xlabel(hcbar,options.colbarTitle)
        else
                clf('reset')
                h1 = subplot(1,2,1); % left hemisphere lateral
                tripatchDG(cort_lh,h1,overlayData_lh(iTime,:,:));        
                view(270,0)
                set(h1, 'color', cfg.background_color);
                alpha 1            
                axis tight; axis equal;        
                shading flat;
                lighting gouraud; 
                material dull;
                hide_axis(gca);        
                camlight_follow(gca);
        
                h3 = subplot(1,2,2); % right hemisphere lateral
                tripatchDG(cort_rh,h3,overlayData_rh(iTime,:,:));
                view(90,0)        
                alpha 1
                set(h3, 'color', cfg.background_color);
                axis tight; axis equal;
                shading flat;
                lighting gouraud; 
                material dull;
                hide_axis(gca);        
                camlight_follow(gca);
        
                pos=[0.1 0.06 0.8150 0.0310];
                hcbar = cbarDGplus(pos,[oLayLimits(1) oLayLimits(2)],olayCmapName,5,[],'top',20);
                xlabel(hcbar,options.colbarTitle)
        end
        sgtitle([num2str(round(timeEpoch(iTime),2)) ' s'])
        M(iTime) = getframe(gcf);
   end
        %
        hold on;
    close
    vname = strcat(options.movTitle,'_','both_hemisphere_',stype,...
        'smooth_',ptype,'_display.avi');
    vidObj=VideoWriter(vname, 'Motion JPEG AVI');
    vidObj.Quality = 100;    
    vidObj.FrameRate = options.frameRate;
    open(vidObj);        
    writeVideo(vidObj,M);
     close(vidObj);
    
end