function cort = load_pial_data(surf_filename)

recondir = get_recondir(1);

if isempty(recondir)
    root = '.';
else
    root = recondir;
end

if nargin < 1 || isempty(surf_filename)
    [pial_fn, fpath] = uigetfile(fullfile(root, '*.pial;*.pial.mat;*.inflated;*.inflated.mat'), 'Choose .mat or .pial file');
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
end