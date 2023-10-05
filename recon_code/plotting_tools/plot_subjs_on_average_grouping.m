function plot_subjs_on_average_grouping(subj_labels, grouping_idx, avgsubj, cfg)
% PLOT_ELEC_ON_AVERAGE_GROUPING    Plots electrodes on average brain.
% Electrodes with the same grouping_idx will have the same color.
%
% subj_labels  : cell array in subj-label format, e.g. {'D14-RPIP10', 'D14-RPIP9',...}
% grouping_idx : is an Nx1 matrix, where N is number of elements in subj_labels
% avgsubj      : char, the name of the average subject folder, e.g.
%                'fsaverage'

subjs = {};
for s = 1:numel(subj_labels)
    label_split = strsplit(subj_labels{s}, '-');
    subjs = cat(1, subjs, label_split(1));
end
usubjs = unique(subjs);

cfg.subj_labels = subj_labels;
cfg.grouping_idx = grouping_idx;

plot_subjs_on_average(usubjs, avgsubj, cfg);
end