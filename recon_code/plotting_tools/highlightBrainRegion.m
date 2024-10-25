function highlightBrainRegion(subject_id, hemisphere, region_name, options)
    % This function highlights a specific brain region from a FreeSurfer brain model.
    % Parameters:
    %   subject_id  : The FreeSurfer subject ID
    %   hemisphere  : 'lh' for left hemisphere or 'rh' for right hemisphere
    %   region_name : The name of the brain region to highlight
    %   color       : The color to use for highlighting
    arguments
        subject_id = 'fsaverage'
        hemisphere = 'lh'
        region_name = {'A6m_L','A6dl_L'}
        options.color = [1 0 1];
        options.parcfn = 'BN_Atlas'; 
    end

    % Define the path to the subject's FreeSurfer directory
    freesurferDir = get_recondir(); % Set this environment variable to your FreeSurfer subjects directory
    if isempty(freesurferDir)
        error('The SUBJECTS_DIR environment variable is not set.');
    end

    subjectDir = fullfile(freesurferDir, subject_id);
    
    % Load the surface and annotation
    surf_path = fullfile(subjectDir, 'surf', [hemisphere '.pial']);
    [vertices, faces] = freesurfer_read_surf(surf_path);

    annot_path = fullfile(subjectDir, 'label', [hemisphere '.' options.parcfn '.annot']);
    [~, label, colortable] = read_annotation(annot_path);
    colortable.struct_names
    % Find the index of the brain region
    region_idx = [];
    for iRegion = 1:length(region_name)
        
        region_idx = [region_idx find(contains(colortable.struct_names, region_name{iRegion}))];
        if isempty(region_idx)
            error(['The region ' region_name ' was not found in the annotation file.']);
        end
    end
    region_vertices = false(size(label));
 
    % Find vertices that belong to the region
    for iRegion = 1:length(region_idx)
       
        region_vertices = region_vertices | (label == colortable.table(region_idx(iRegion), 5));
    end
    size(vertices)
     size(region_vertices)
    % Display the brain surface
    % Display the brain surface
    figure;
    patch('vertices', vertices, 'faces', faces, 'FaceVertexCData', double(~region_vertices), ...
          'FaceColor', 'interp', 'EdgeColor', 'none', 'FaceAlpha', 1);
    hold on;

    % Highlight the selected region
%     patch('vertices', vertices, 'faces', faces(region_vertices, :), 'FaceVertexCData', repmat(color, sum(region_vertices), 1), ...
%           'FaceColor', 'flat', 'EdgeColor', 'none');


    % Adjust the view, lighting, and add colorbar if needed
   if strcmp(hemisphere, 'lh')
    view(270,0)
    elseif strcmp(hemisphere, 'rh')
    view(90,0)
    elseif strcmp(hemisphere, 'bh')
    view(180,0)
    end
    lighting gouraud;
    material dull;
    colormap([options.color; 0.5 0.5 0.5]); % White for non-highlighted, specified color for the region
    axis tight; axis equal;
    shading interp;
    camlight_follow(gca);
    axis off;
end
