function [mask_to_show,color,esize] = parse_cfg_labels_idx(alllabels, cfg)

mask_to_show = zeros(numel(alllabels), 1);
color = zeros(numel(alllabels), 3);
esize = zeros(numel(alllabels), 1);
for c = 1:numel(cfg.subj_labels)
    idx = find(strcmp(alllabels, cfg.subj_labels{c}), 1, 'first');
    if ~isempty(idx)
        if cfg.grouping_idx(c) == 0
            mask_to_show(idx,1) = 0;
            color(idx,:) = [0 0 0];
            esize(idx,:) = cfg.elec_size(1);
        else
            mask_to_show(idx,1) = 1;
            color(idx,:) = cfg.elec_colors(cfg.grouping_idx(c),:);
            if numel(cfg.elec_size) > 1
                esize(idx,:) = cfg.elec_size(cfg.grouping_idx(c));
            else
                esize(idx,:) = cfg.elec_size(1);
            end
        end
    end
end

mask_to_show = mask_to_show == 1;
    
end