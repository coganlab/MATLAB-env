function plot_annotation(handle_surf, annot_filename, cfg)

if nargin < 3
    cfg = [];
end
cfg = plot_defaults(cfg);

recondir = get_recondir(1);

if isempty(recondir)
    root = '.';
else
    root = recondir;
end

if nargin < 1 || isempty(handle_surf)
    ax = gca;
    for a = 1:numel(ax.Children)
        if contains(class(ax.Children(a)), '.Patch')
            handle_surf = ax.Children(a);
            break;
        end
    end
end

if nargin < 2 || isempty(annot_filename)
    [annot_fn, fpath] = uigetfile(fullfile(root, '*.annot;*.annot.mat'), 'Choose .annot file');
    if ~annot_fn
        return;
    end
    annot_fn = fullfile(fpath, annot_fn);
else
    annot_fn = annot_filename;
end

fprintf('Loading: %s\n', annot_fn);
if contains(annot_fn, '.mat')
    load(annot_fn);
    albl = annot.label;
    actbl = annot.colortable;
else
    [~,albl,actbl]=read_annotation(annot_fn);
end
actbl.table(43,1:3)=255*[1 1 1]*.7; %make medial wall the same shade of grey as functional plots


[~,locTable]=ismember(albl,actbl.table(:,5));

locTable(locTable==0)=1; % for the case where the label for the vertex says 0
fvcdat=actbl.table(locTable,1:3)./255; %scale RGB values to 0-1

if ~isempty(cfg.annot_index)
    idx = ismember(locTable, cfg.annot_index);
    handle_surf.FaceVertexCData(idx,:) = fvcdat(idx,:);
else
    handle_surf.FaceVertexCData = fvcdat;
end

for a = 1:numel(actbl.struct_names)
    actbl.struct_names{a} = sprintf('%d %s', a, actbl.struct_names{a});
end

legendf(actbl.struct_names, actbl.table(1:numel(actbl.struct_names),1:3)./255);

end