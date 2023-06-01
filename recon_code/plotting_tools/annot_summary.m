function out = annot_summary(subj, annot_fn)
% e.g. annot_summary('D14', 'h.aparc.a2009s.annot')
% returns region name + index. These indices can be used in
% cfg.annot_index
recondir = get_recondir(1);

load(fullfile(recondir, subj, 'label', sprintf('b%s.mat', annot_fn)));
actbl = annot.colortable;

out = actbl.struct_names;
for o = 1:numel(out)
    out{o,2} = o;
end
end