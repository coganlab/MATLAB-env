function handle_surf = plot_surf(surf_filename, cfg)
% PLOT_SURF    plots .pial or .mat surface data
%     handles = plot_surf(surf_filename, cfg);
%     All arguments are optional
%     Type "help plot_defaults" to see cfg parameters

recondir = get_recondir(1);

%% Load Defaults like electrode size, font color, etc.

if nargin < 2
    cfg = [];
end

cfg = plot_defaults(cfg);

if isempty(recondir)
    root = '.';
else
    root = recondir;
end

%% Load .pial data
if nargin < 1 || isempty(surf_filename)
    [pial_fn, fpath] = uigetfile(fullfile(root, '*.pial;*.pial.mat'), 'Choose .mat or .pial file');
    if ~pial_fn
        return;
    end
    pial_fn = fullfile(fpath, pial_fn);
else
    pial_fn = surf_filename;
end
fprintf('Loading: %s\n', pial_fn);
if strcmp(pial_fn(end-3:end), '.mat')
    data = load(pial_fn);
    cort.vert = data.surf_brain.coords;
    cort.tri = data.surf_brain.faces;
else
    [cort.vert, cort.tri] = freesurfer_read_surf(fullfile(pial_fn));
end


%% Plot the surface and adjust lighting
surf_color = repmat(cfg.surf_color, size(cort.vert,1), 1);

f = figure;
handle_surf=trisurf(cort.tri, cort.vert(:, 1), cort.vert(:, 2), cort.vert(:, 3), 'FaceVertexCData', surf_color);
set(f, 'color', cfg.background_color);

axis tight; axis equal;
shading interp;
lighting gouraud; material dull;
alpha(cfg.alpha);

hide_axis(gca);

camlight_follow(gca);

hold on;

end