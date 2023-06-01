function handle_labels = plot_elec_labels(elec_xyz, labels, fontsize, fontcolor, label_skip_n)

idx = 1:label_skip_n:numel(labels);
handle_labels = text(elec_xyz(idx,1), elec_xyz(idx,2), elec_xyz(idx,3), labels(idx), 'color', fontcolor, 'fontsize', fontsize);

end