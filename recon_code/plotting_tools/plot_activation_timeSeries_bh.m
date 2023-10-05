function plot_activation_timeSeries_bh(subj_labels, activation_values, options)

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
    options.transparentPoint = 0.7;
    options.frameRate double =  20 % frameRate: Frame rate of the movie (e.g. 120)
    options.movTitle char = 'patient_space_time_activation' % movTitle: Filename to be saved (e.g. 'S23_highGamma')
    options.colbarTitle string = 'z-score' % colbarTitle: Color axis label (e.g. 'z-score')
    options.colorSteps integer = 1000;
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


%% Plot the surface and elec density of left hemisphere
cort_lh = load_pial_data(fullfile(recondir, avgsubj, 'surf', smooth_fn_lh));

activationV_lh = zeros(size(cort_lh.vert,1), size(activation_values_lh,2));

tic
if 1
    parfor v = 1:size(cort_lh.vert, 1)
        V = cort_lh.vert(v,:);
        dist_to_each_elec = sqrt(sum((groupAvgCoords_lh - V).^2, 2));
        
        sigma = thresh/2.355;
        gauss_kernel = exp(-dist_to_each_elec.^2./(2*sigma^2));       
         
        activationV_lh(v,:) = sum(gauss_kernel.*activation_values_lh);
    end
end


toc
activationV_lh(activationV_lh<=cLim(1)) = 0;

%% Plot the surface and elec density of right hemisphere
cort_rh = load_pial_data(fullfile(recondir, avgsubj, 'surf', smooth_fn_rh));

activationV_rh = zeros(size(cort_rh.vert,1), size(activation_values_rh,2));

tic
if 1
    parfor v = 1:size(cort_rh.vert, 1)
        V = cort_rh.vert(v,:);
        dist_to_each_elec = sqrt(sum((groupAvgCoords_rh - V).^2, 2));
        
        sigma = thresh/2.355;
        gauss_kernel = exp(-dist_to_each_elec.^2./(2*sigma^2));       
         
        activationV_rh(v,:) = sum(gauss_kernel.*activation_values_rh);
    end
end


toc
activationV_rh(activationV_rh<=cLim(1)) = 0;
%%

    
    scrsize = get(0, 'Screensize');
    f = figure('Position', [scrsize(1) scrsize(2) scrsize(3)/2 scrsize(4)/2]);
    cort_lh = load_pial_data(fullfile(recondir, avgsubj, 'surf', pial_fn_lh));
    cort_rh = load_pial_data(fullfile(recondir, avgsubj, 'surf', pial_fn_rh));
    n_steps = options.colorSteps;
    c_white = options.transparentPoint;
    c_array = linspace(cLim(1),cLim(2),n_steps);
    c_step_white = find(c_array>=c_white,1);
    diff_step = n_steps-2.*c_step_white;
    cm = make_color_gradient_diff_steps([0.5 0.5 0.5;1 1 1; 1 1 0; 1 0 0], [c_step_white c_step_white diff_step]);
    
    
    for iTime = 1:size(activationV_rh,2)
        clf('reset')
        subplot(2,2,1); % left hemisphere lateral
        trisurf(cort_lh.tri, cort_lh.vert(:, 1), cort_lh.vert(:, 2), cort_lh.vert(:, 3), 'FaceVertexCData', activationV_lh(:,iTime));
        view(270,0)
        alpha 1            
        axis tight; axis equal;
        caxis(cLim)
        colormap(cm) 
        set(f, 'color', cfg.background_color);
        shading flat;
        lighting gouraud; 
        material dull;
        hide_axis(gca);        
        camlight_follow(gca);

        subplot(2,2,3);% left hemisphere medial
        trisurf(cort_lh.tri, cort_lh.vert(:, 1), cort_lh.vert(:, 2), cort_lh.vert(:, 3), 'FaceVertexCData', activationV_lh(:,iTime));
        alpha 1            
        axis tight; axis equal;
        view(90,0)
        caxis(cLim)
        colormap(cm) 
        set(f, 'color', cfg.background_color);
        shading flat;
        lighting gouraud; 
        material dull;
        hide_axis(gca);        
        camlight_follow(gca);


        subplot(2,2,2); % right hemisphere lateral
        trisurf(cort_rh.tri, cort_rh.vert(:, 1), cort_rh.vert(:, 2), cort_rh.vert(:, 3), 'FaceVertexCData', activationV_rh(:,iTime));
        view(90,0)
        alpha 1            
        axis tight; axis equal;
        set(f, 'color', cfg.background_color);
        shading flat;
        lighting gouraud; 
        material dull;
        hide_axis(gca);        
        camlight_follow(gca);

        caxis(cLim)
        colormap(cm) 

        subplot(2,2,4);% right hemisphere medial
        trisurf(cort_rh.tri, cort_rh.vert(:, 1), cort_rh.vert(:, 2), cort_rh.vert(:, 3), 'FaceVertexCData', activationV_rh(:,iTime));
        alpha 1            
        axis tight; axis equal;
        view(270,0)
        caxis(cLim)
        colormap(cm)         
        set(f, 'color', cfg.background_color);
        shading flat;
        lighting gouraud; 
        material dull;
        hide_axis(gca);        
        camlight_follow(gca);
                       
            %set_caxis_color(0,[0.5 0.5 0.5])            
        

        ax1 = gca;
        hcb=colorbar('SouthOutside');
        ax1Pos = ax1.Position;
        pos = hcb.Position;
        pos(4) = 1*pos(4);
        hcb.Position = pos;
        % The above automatically change the ax1.Position
        % We restore the origninal ax1.Position
        ax1.Position = ax1Pos;

        ylabel(hcb,options.colbarTitle)
        sgtitle([num2str(round(timeEpoch(iTime),2)) ' s'])
        M(iTime) = getframe(gcf);
        %
    end
    size(M)
%     title(tt{i});
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