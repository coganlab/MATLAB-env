function handles = plot_subj_grouping(subj_labels, grouping_idx, cfg)
subjs = {};
labels = {};
for s = 1:numel(subj_labels)
    label_split = strsplit(subj_labels{s}, '-');
    subjs = cat(1, subjs, label_split(1));
    labels = cat(1, labels, label_split(2));
end
usubjs = unique(subjs);
assert(numel(usubjs) == 1);

cfg.subj_labels = labels;
cfg.grouping_idx = grouping_idx;

handles = plot_subj(usubjs{1}, cfg);
end